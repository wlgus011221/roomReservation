package egovframework.room.service.impl;

import java.util.List;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import egovframework.room.service.UserService;
import egovframework.room.service.UserDefaultVO;
import egovframework.room.service.UserVO;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserServiceImpl extends EgovAbstractServiceImpl implements UserService {

    private static final Logger LOGGER = LoggerFactory.getLogger(UserServiceImpl.class);

    private final UserMapper userMapper;

    @Override
    public String insertUser(UserVO vo) throws Exception {
        LOGGER.debug(vo.toString());
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
    public List<?> selectUserList(UserDefaultVO searchVO) throws Exception {
        return userMapper.selectUserList(searchVO);
    }

    @Override
    public int selectUserListTotCnt(UserDefaultVO searchVO) {
        return userMapper.selectUserListTotCnt(searchVO);
    }
}