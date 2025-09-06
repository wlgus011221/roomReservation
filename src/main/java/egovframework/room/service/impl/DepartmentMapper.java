package egovframework.room.service.impl;

import java.util.List;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import egovframework.room.service.DepartmentVO;

@Mapper
public interface DepartmentMapper {

    void insertDepartment(DepartmentVO vo) throws Exception;
    void updateDepartment(DepartmentVO vo) throws Exception;
    void deleteDepartment(DepartmentVO vo) throws Exception;
    DepartmentVO selectDepartment(DepartmentVO vo) throws Exception;
    List<DepartmentVO> selectDepartmentList(DepartmentVO vo) throws Exception;
    int selectDepartmentListTotCnt(DepartmentVO vo);
}