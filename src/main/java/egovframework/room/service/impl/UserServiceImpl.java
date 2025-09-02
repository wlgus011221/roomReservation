package egovframework.room.service.impl;

import java.util.List;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.egovframe.rte.fdl.cmmn.exception.FdlException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import egovframework.room.service.UserService;
import egovframework.room.service.UserVO;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserServiceImpl extends EgovAbstractServiceImpl implements UserService {

    private static final Logger LOGGER = LoggerFactory.getLogger(UserServiceImpl.class);

    private final UserMapper userMapper;

    @Override
    public String insertUser(UserVO vo) throws Exception {
        LOGGER.debug("사용자 등록: " + vo.toString());
        
        userMapper.insertUser(vo);
        return String.valueOf(vo.getUserIdx());
    }

    @Override
    public void updateUser(UserVO vo) throws Exception {
        userMapper.updateUser(vo);
    }

    @Override
    public void deleteUser(UserVO vo) throws Exception {
        userMapper.deleteUser(vo);
    }

    @Override
    public UserVO selectUser(UserVO vo) throws Exception {
        UserVO resultVO = userMapper.selectUser(vo);
        if (resultVO == null)
            throw processException("info.nodata.msg");
        return resultVO;
    }

    @Override
    public List<?> selectUserList(UserVO vo) throws Exception {
        return userMapper.selectUserList(vo);
    }

    @Override
    public int selectUserListTotCnt(UserVO vo) {
        return userMapper.selectUserListTotCnt(vo);
    }
    
    @Override
    public UserVO selectLoginCheck(UserVO vo) throws Exception {
        return userMapper.selectLoginCheck(vo);
    }
    
    @Override
    public void updatePassword(Integer userIdx, String hashedCurrentPassword, String hashedNewPassword) throws Exception {
        
        // 1. 기존 사용자 정보 조회
        UserVO userVO = new UserVO();
        userVO.setUserIdx(userIdx);
        UserVO existingUser = userMapper.selectUser(userVO);

        if (existingUser == null) {
            throw new FdlException("사용자 정보를 찾을 수 없습니다.");
        }
        if (!hashedCurrentPassword.equals(existingUser.getPasswd())) {
            throw new FdlException("현재 비밀번호가 일치하지 않습니다.");
        }

        // 3. 새 비밀번호로 업데이트
        userVO.setPasswd(hashedNewPassword);
        int result = userMapper.updatePassword(userVO);

        if (result == 0) {
            throw new FdlException("비밀번호 변경에 실패했습니다.");
        }
    }
}