package egovframework.room.service;

import java.util.List;

public interface RoomService {

    /**
     * 회의실을 등록한다.
     * @param vo - 등록할 정보가 담긴 RoomVO
     * @return 등록 결과
     * @exception Exception
     */
    String insertRoom(RoomVO vo) throws Exception;

    /**
     * 회의실을 수정한다.
     * @param vo - 수정할 정보가 담긴 RoomVO
     * @return void형
     * @exception Exception
     */
    void updateRoom(RoomVO vo) throws Exception;

    /**
     * 회의실을 삭제한다.
     * @param vo - 삭제할 정보가 담긴 RoomVO
     * @return void형
     * @exception Exception
     */
    void deleteRoom(RoomVO vo) throws Exception;

    /**
     * 회의실을 조회한다.
     * @param vo - 조회할 정보가 담긴 RoomVO
     * @return 조회한 회의실
     * @exception Exception
     */
    RoomVO selectRoom(RoomVO vo) throws Exception;

    /**
     * 회의실 목록을 조회한다.
     * @param searchVO - 조회할 정보가 담긴 VO
     * @return 회의실 목록
     * @exception Exception
     */
    List<RoomVO> selectRoomList(RoomVO vo) throws Exception;

    /**
     * 회의실 총 갯수를 조회한다.
     * @param searchVO - 조회할 정보가 담긴 VO
     * @return 회의실 총 갯수
     * @exception
     */
    int selectRoomListTotCnt(RoomVO vo);
    
    /**
     * 전체 시설 목록을 조회한다.
     * @return 시설 목록
     * @exception Exception
     */
    List<FacilityVO> selectAllFacilities() throws Exception;
}