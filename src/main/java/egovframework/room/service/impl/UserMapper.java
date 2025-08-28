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
    List<?> selectUserList(UserDefaultVO searchVO) throws Exception;
    int selectUserListTotCnt(UserDefaultVO searchVO);
}