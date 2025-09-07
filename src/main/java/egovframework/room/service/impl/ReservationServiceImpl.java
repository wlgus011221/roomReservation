package egovframework.room.service.impl;

import java.util.List;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import egovframework.room.service.RecurringReservationVO;
import egovframework.room.service.ReservationService;
import egovframework.room.service.ReservationVO;
import egovframework.room.service.RoomVO;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ReservationServiceImpl extends EgovAbstractServiceImpl implements ReservationService {

    private static final Logger LOGGER = LoggerFactory.getLogger(ReservationServiceImpl.class);

    private final ReservationMapper reservationMapper;
    
    @Override
    @Transactional
    public void insertSingleReservation(ReservationVO vo) throws Exception {
        reservationMapper.insertSingleReservation(vo);
    }
    
    @Override
    @Transactional
    public int insertRecurringReservation(RecurringReservationVO vo) throws Exception {
        reservationMapper.insertRecurringReservation(vo);
        return vo.getRecurringIdx();
    }
    
    @Override
    @Transactional
    public void insertRecurringReservationDetail(ReservationVO vo) throws Exception {
        reservationMapper.insertRecurringReservationDetail(vo);
    }

	@Override
	public ReservationVO selectReservation(ReservationVO vo) throws Exception {
		ReservationVO resultVO = reservationMapper.selectReservation(vo);
        if (resultVO == null)
            throw processException("info.nodata.msg");
        return resultVO;
	}

	@Override
	public List<ReservationVO> selectReservationList(ReservationVO vo) throws Exception {
		return reservationMapper.selectReservationList(vo);
	}

	@Override
	public void updateReservation(ReservationVO vo) throws Exception {
		reservationMapper.updateReservation(vo);
	}

	@Override
	public void deleteReservation(ReservationVO vo) throws Exception {
		reservationMapper.deleteReservation(vo);
	}
}