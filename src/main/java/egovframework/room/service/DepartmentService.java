package egovframework.room.service;

import java.util.List;

public interface DepartmentService {

    /**
     * 부서를 등록한다.
     * @param vo - 등록할 정보가 담긴 DepartmentVO
     * @return 등록 결과
     * @exception Exception
     */
    String insertDepartment(DepartmentVO vo) throws Exception;

    /**
     * 부서를 수정한다.
     * @param vo - 수정할 정보가 담긴 DepartmentVO
     * @return void형
     * @exception Exception
     */
    void updateDepartment(DepartmentVO vo) throws Exception;

    /**
     * 부서를 삭제한다.
     * @param vo - 삭제할 정보가 담긴 DepartmentVO
     * @return void형
     * @exception Exception
     */
    void deleteDepartment(DepartmentVO vo) throws Exception;

    /**
     * 부서를 조회한다.
     * @param vo - 조회할 정보가 담긴 DepartmentVO
     * @return 조회한 부서
     * @exception Exception
     */
    DepartmentVO selectDepartment(DepartmentVO vo) throws Exception;

    /**
     * 부서 목록을 조회한다.
     * @param searchVO - 조회할 정보가 담긴 VO
     * @return 부서 목록
     * @exception Exception
     */
    List<?> selectDepartmentList(DepartmentVO vo) throws Exception;

    /**
     * 부서 총 갯수를 조회한다.
     * @param searchVO - 조회할 정보가 담긴 VO
     * @return 부서 총 갯수
     * @exception
     */
    int selectDepartmentListTotCnt(DepartmentVO vo);
}