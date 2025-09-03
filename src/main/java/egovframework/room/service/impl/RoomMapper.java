package egovframework.room.service.impl;

import java.util.List;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import egovframework.room.service.RoomVO;
import egovframework.room.service.FacilityVO;

@Mapper
public interface RoomMapper {
    
    void insertRoom(RoomVO vo) throws Exception;
    void updateRoom(RoomVO vo) throws Exception;
    void deleteRoom(RoomVO vo) throws Exception;
    
    // 회의실 상세 조회
    RoomVO selectRoom(RoomVO vo) throws Exception;
    
    // 회의실 목록 조회
    List<RoomVO> selectRoomList(RoomVO vo) throws Exception;
    
    // 회의실 총 개수 조회
    int selectRoomListTotCnt(RoomVO vo);

    // 회의실에 시설 추가
    void insertRoomFacility(RoomVO vo) throws Exception;
    
    // 회의실 시설 삭제 (수정 시 기존 시설 삭제 후 재등록)
    void deleteRoomFacility(RoomVO vo) throws Exception;
    
    // 전체 시설 목록 조회
    List<FacilityVO> selectAllFacilities() throws Exception;

}