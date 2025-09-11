package egovframework.room.service.impl;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import egovframework.room.service.RecurringReservationVO;
import egovframework.room.service.ReservationVO;

@Mapper
public interface ReservationMapper {
    
    void insertSingleReservation(ReservationVO vo) throws Exception;
    
    void insertRecurringReservation(RecurringReservationVO vo) throws Exception;
    
    void insertRecurringReservationDetail(ReservationVO vo) throws Exception;

    ReservationVO selectReservation(ReservationVO vo) throws Exception;

    List<ReservationVO> selectReservationList(ReservationVO vo) throws Exception;
    
    List<ReservationVO> selectMyReservationList(ReservationVO vo) throws Exception;
    
    int selectMyReservationListTotCnt(ReservationVO vo) throws Exception;
    
    void updateReservation(ReservationVO vo) throws Exception;
    
    void deleteReservation(ReservationVO vo) throws Exception;
    
    void deleteRecurringReservation(RecurringReservationVO vo) throws Exception;
    
    int selectCountOverlappingReservations(ReservationVO vo) throws Exception;
    
    int countTotalReservationsByDate(String date) throws Exception;
    
    int countMyReservationsByDate(Map<String, Object> param) throws Exception;
    
    List<ReservationVO> selectReservationListByDate(ReservationVO vo) throws Exception;
}