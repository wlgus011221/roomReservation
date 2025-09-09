package egovframework.room.service;

import java.util.Date;
import java.util.List;
import java.util.Map;

public interface ReservationService {

    /**
     * 단일 예약을 등록한다.
     * @param vo - 등록할 정보가 담긴 ReservationVO
     */
    void insertSingleReservation(ReservationVO vo) throws Exception;
    
    /**
     * 반복 예약 규칙을 등록한다.
     * @param vo - 등록할 정보가 담긴 RecurringReservationVO
     * @return 등록된 반복 예약 규칙의 ID
     */
    int insertRecurringReservation(RecurringReservationVO vo) throws Exception;

    /**
     * 반복 예약을 등록한다.
     * @param vo - 등록할 정보가 담긴 ReservationVO
     */
    void insertRecurringReservationDetail(ReservationVO vo) throws Exception;
    
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
     * 내 예약 목록을 조회한다.
     * @param searchVO - 조회할 정보가 담긴 VO
     * @return 예약 목록
     */
    List<ReservationVO> selectMyReservationList(ReservationVO vo) throws Exception;
    
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
}