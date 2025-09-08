package egovframework.room.service;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

public class ReservationVO extends DefaultVO { // 페이징을 위한 상위 클래스 상속

    private static final long serialVersionUID = 1L;
    
    /** 예약 인덱스 */
    private int reservationIdx;

    /** 회의실 인덱스 */
    private int roomIdx;
    
    /** 예약자 인덱스 */
    private int userIdx;
    
    /** 회의 제목 */
    private String title;
    
    /** 참석 인원 */
    private int attendees;
    
    /** 예약 시작 날짜 */
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date startDatetime;
    
    /** 예약 종료 날짜 */
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date endDatetime;

    
    /** 회의 내용 */
    private String content;

    /** 반복 예약 여부 */
    private boolean isRecurring;

    /** 반복 예약 규칙 인덱스 */
    private Integer recurringIdx;

    // 조인용 필드
    private String roomName;
    private String userName;
	public int getReservationIdx() {
		return reservationIdx;
	}
	public void setReservationIdx(int reservationIdx) {
		this.reservationIdx = reservationIdx;
	}
	public int getRoomIdx() {
		return roomIdx;
	}
	public void setRoomIdx(int roomIdx) {
		this.roomIdx = roomIdx;
	}
	public int getUserIdx() {
		return userIdx;
	}
	public void setUserIdx(int userIdx) {
		this.userIdx = userIdx;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public int getAttendees() {
		return attendees;
	}
	public void setAttendees(int attendees) {
		this.attendees = attendees;
	}
	
	public Date getStartDatetime() {
        return startDatetime;
    }

    public void setStartDatetime(Date startDatetime) {
        this.startDatetime = startDatetime;
    }

    public Date getEndDatetime() {
        return endDatetime;
    }

    public void setEndDatetime(Date endDatetime) {
        this.endDatetime = endDatetime;
    }
    
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public boolean isRecurring() {
		return isRecurring;
	}
	public void setRecurring(boolean isRecurring) {
		this.isRecurring = isRecurring;
	}
	public Integer getRecurringIdx() {
		return recurringIdx;
	}
	public void setRecurringIdx(Integer recurringIdx) {
		this.recurringIdx = recurringIdx;
	}
	public String getRoomName() {
		return roomName;
	}
	public void setRoomName(String roomName) {
		this.roomName = roomName;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	
	@Override
	public String toString() {
		return "ReservationVO [reservationIdx=" + reservationIdx + ", roomIdx=" + roomIdx + ", userIdx=" + userIdx
				+ ", title=" + title + ", attendees=" + attendees + ", startDatetime=" + startDatetime
				+ ", endDatetime=" + endDatetime + ", content=" + content + ", isRecurring=" + isRecurring
				+ ", recurringIdx=" + recurringIdx + ", roomName=" + roomName + ", userName=" + userName + "]";
	}
	
	
    
}