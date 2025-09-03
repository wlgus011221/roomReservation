package egovframework.room.service.impl;

import java.util.List;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import egovframework.room.service.FacilityVO;
import egovframework.room.service.RoomService;
import egovframework.room.service.RoomVO;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class RoomServiceImpl extends EgovAbstractServiceImpl implements RoomService {

    private static final Logger LOGGER = LoggerFactory.getLogger(RoomServiceImpl.class);

    private final RoomMapper roomMapper;

    @Override
    @Transactional
    public String insertRoom(RoomVO vo) throws Exception {
        try {
            // 1. rooms 테이블에 회의실 정보 등록
            roomMapper.insertRoom(vo); 
            
            LOGGER.debug("Generated roomIdx: " + vo.getRoomIdx());
            LOGGER.debug("Facilities list size: " + (vo.getFacilities() != null ? vo.getFacilities().size() : 0));
                    
            // 2. room_facility 테이블에 시설 정보 등록 (선택된 시설이 있을 경우)
            if (vo.getFacilities() != null && !vo.getFacilities().isEmpty()) {
                 // MyBatis에서 foreach를 사용해 벌크 인서트 처리
                roomMapper.insertRoomFacility(vo);
            }
            
            return String.valueOf(vo.getRoomIdx());
        } catch (Exception e) {
            LOGGER.error("Failed to insert room or facilities: ", e);
            throw e; // Re-throw the exception to trigger transaction rollback
        }
    }

    @Override
    public void updateRoom(RoomVO vo) throws Exception {
        // 1. rooms 테이블 정보 업데이트
        roomMapper.updateRoom(vo);
        
        // 2. room_facility 기존 시설 정보 삭제 후 재등록
        roomMapper.deleteRoomFacility(vo);
        
        if (vo.getFacilities() != null && !vo.getFacilities().isEmpty()) {
            roomMapper.insertRoomFacility(vo);
        }
    }

    @Override
    @Transactional
    public void deleteRoom(RoomVO vo) throws Exception {
        // rooms 테이블에 ON DELETE CASCADE 옵션이 있으므로 room_facility는 자동으로 삭제됨
        roomMapper.deleteRoom(vo);
    }

    @Override
    public RoomVO selectRoom(RoomVO vo) throws Exception {
        RoomVO resultVO = roomMapper.selectRoom(vo);
        if (resultVO == null)
            throw processException("info.nodata.msg");
        return resultVO;
    }

    @Override
    public List<RoomVO> selectRoomList(RoomVO vo) throws Exception {
        return roomMapper.selectRoomList(vo);
    }

    @Override
    public int selectRoomListTotCnt(RoomVO vo) {
        return roomMapper.selectRoomListTotCnt(vo);
    }
    
    @Override
    public List<FacilityVO> selectAllFacilities() throws Exception {
        return roomMapper.selectAllFacilities();
    }
}