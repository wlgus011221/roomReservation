package egovframework.room.service;

import java.util.List;
import java.util.Map;

public interface ReservationService {

    /**
     * 단일 예약을 등록한다.
     * @param vo - 등록할 정보가 담긴 ReservationVO
     */
    void insertSingleReservation(ReservationVO vo) throws Exception;
    
    /**
     * 예약을 조회한다.
     * @param vo - 조회할 정보가 담긴 ReservationVO
     * @return 조회된 예약 정보
     */
    ReservationVO selectReservation(ReservationVO vo) throws Exception;
    
    /**
     * 예약 목록을 조회한다.
     * @param searchVO - 조회할 정보가 담긴 VO
     * @return 예약 목록
     */
    List<ReservationVO> selectReservationList(ReservationVO vo) throws Exception;
    
    /**
     * 내 예약 목록을 조회한다. (페이징 처리)
     * @param searchVO - 조회할 정보가 담긴 VO
     * @return 예약 목록
     */
    List<ReservationVO> selectMyReservationList(ReservationVO vo) throws Exception;
    
    /**
     * 내 예약 목록을 조회한다.
     * @param searchVO - 조회할 정보가 담긴 VO
     * @return 예약 목록
     */
    List<ReservationVO> selectMyAllReservationList(ReservationVO vo) throws Exception;
    
    /**
     * 내 예약 총 갯수를 조회한다.
     * @param vo - 조회할 정보가 담긴 VO
     * @return 내 예약 총 갯수
     */
    int selectMyReservationListTotCnt(ReservationVO vo) throws Exception;
    
    /**
     * 예약을 수정한다.
     * @param vo - 수정할 정보가 담긴 ReservationVO
     */
    void updateReservation(ReservationVO vo) throws Exception;

    /**
     * 예약을 삭제한다.
     * @param vo - 삭제할 정보가 담긴 ReservationVO
     */
    void deleteReservation(ReservationVO vo) throws Exception;
    
    /**
     * 특정 시간대에 중복되는 예약이 있는지 확인
     * @param reservationVO
     * @return 중복되는 예약의 수
     */
    int countOverlappingReservations(ReservationVO reservationVO) throws Exception;
    
    int countTotalReservationsByDate(String date) throws Exception;
    
    int countMyReservationsByDate(Map<String, Object> param) throws Exception;
    
    /**
     * 특정 날짜의 예약 목록을 조회한다.
     * @param paramMap - 조회할 날짜 정보가 담긴 Map
     * @return 해당 날짜의 예약 목록
     */
    List<ReservationVO> selectReservationListByDate(ReservationVO vo) throws Exception;
}