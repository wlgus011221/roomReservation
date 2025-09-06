package egovframework.room.service.impl;

import java.util.List;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import egovframework.room.service.UserDefaultVO;
import egovframework.room.service.UserVO;

@Mapper
public interface UserMapper {

    void insertUser(UserVO vo) throws Exception;
    void updateUser(UserVO vo) throws Exception;
    void deleteUser(UserVO vo) throws Exception;
    UserVO selectUser(UserVO vo) throws Exception;
    List<?> selectUserList(UserVO vo) throws Exception;
    int selectUserListTotCnt(UserVO vo);
    
    // 중복 체크용 (개수 반환)
    int selectUserById(UserVO vo) throws Exception;
    int selectUserByEmail(UserVO vo) throws Exception;
    
    UserVO selectLoginCheck(UserVO vo) throws Exception;
	int updatePassword(UserVO vo);
}