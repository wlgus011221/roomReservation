package egovframework.room.service.impl;

import java.util.List;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import egovframework.room.service.DepartmentService;
import egovframework.room.service.DepartmentDefaultVO;
import egovframework.room.service.DepartmentVO;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class DepartmentServiceImpl extends EgovAbstractServiceImpl implements DepartmentService {

    private static final Logger LOGGER = LoggerFactory.getLogger(DepartmentServiceImpl.class);

    private final DepartmentMapper departmentMapper;

    @Override
    public String insertDepartment(DepartmentVO vo) throws Exception {
        LOGGER.debug(vo.toString());
        departmentMapper.insertDepartment(vo);
        return String.valueOf(vo.getDepartmentIdx());
    }

    @Override
    public void updateDepartment(DepartmentVO vo) throws Exception {
        departmentMapper.updateDepartment(vo);
    }

    @Override
    public void deleteDepartment(DepartmentVO vo) throws Exception {
        departmentMapper.deleteDepartment(vo);
    }

    @Override
    public DepartmentVO selectDepartment(DepartmentVO vo) throws Exception {
        DepartmentVO resultVO = departmentMapper.selectDepartment(vo);
        if (resultVO == null)
            throw processException("info.nodata.msg");
        return resultVO;
    }

    @Override
    public List<?> selectDepartmentList(DepartmentDefaultVO searchVO) throws Exception {
        return departmentMapper.selectDepartmentList(searchVO);
    }

    @Override
    public int selectDepartmentListTotCnt(DepartmentDefaultVO searchVO) {
        return departmentMapper.selectDepartmentListTotCnt(searchVO);
    }
}