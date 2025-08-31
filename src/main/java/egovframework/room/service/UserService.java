package egovframework.room.service;

import java.util.List;

public interface UserService {

    /**
     * 사용자를 등록한다.
     * @param vo - 등록할 정보가 담긴 UserVO
     * @return 등록 결과
     * @exception Exception
     */
    String insertUser(UserVO vo) throws Exception;

    /**
     * 사용자를 수정한다.
     * @param vo - 수정할 정보가 담긴 UserVO
     * @return void형
     * @exception Exception
     */
    void updateUser(UserVO vo) throws Exception;

    /**
     * 사용자를 삭제한다.
     * @param vo - 삭제할 정보가 담긴 UserVO
     * @return void형
     * @exception Exception
     */
    void deleteUser(UserVO vo) throws Exception;

    /**
     * 사용자를 조회한다.
     * @param vo - 조회할 정보가 담긴 UserVO
     * @return 조회한 사용자
     * @exception Exception
     */
    UserVO selectUser(UserVO vo) throws Exception;

    /**
     * 사용자 목록을 조회한다.
     * @param searchVO - 조회할 정보가 담긴 VO
     * @return 사용자 목록
     * @exception Exception
     */
    List<?> selectUserList(UserVO searchVO) throws Exception;

    /**
     * 사용자 총 갯수를 조회한다.
     * @param searchVO - 조회할 정보가 담긴 VO
     * @return 사용자 총 갯수
     * @exception
     */
    int selectUserListTotCnt(UserVO searchVO);
}