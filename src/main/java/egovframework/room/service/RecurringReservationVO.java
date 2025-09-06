package egovframework.room.service;

import java.util.Date;

public class RecurringReservationVO {

    private static final long serialVersionUID = 1L;

    /** 반복 예약 인덱스 */
    private int recurringIdx;

    /** 반복 주기 */
    private String recurrenceType;

    /** 반복 요일 (주간 반복 시에만) */
    private String daysOfWeek;
    
    /** 반복 시작일 */
    private Date startDate;
    
    /** 반복 종료일 */
    private Date endDate;

    
	public int getRecurringIdx() {
		return recurringIdx;
	}

	public void setRecurringIdx(int recurringIdx) {
		this.recurringIdx = recurringIdx;
	}

	public String getRecurrenceType() {
		return recurrenceType;
	}

	public void setRecurrenceType(String recurrenceType) {
		this.recurrenceType = recurrenceType;
	}

	public String getDaysOfWeek() {
		return daysOfWeek;
	}

	public void setDaysOfWeek(String daysOfWeek) {
		this.daysOfWeek = daysOfWeek;
	}

	public Date getStartDate() {
		return startDate;
	}

	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}

	public Date getEndDate() {
		return endDate;
	}

	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
    
    
}