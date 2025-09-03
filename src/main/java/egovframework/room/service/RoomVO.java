package egovframework.room.service;

import java.util.List;

public class RoomVO extends RoomDefaultVO { // 페이징을 위한 상위 클래스 상속

    private static final long serialVersionUID = 1L;

    /** 회의실 인덱스 */
    private int roomIdx;
    
    /** 회의실 이름 */
    private String name;
    
    /** 수용인원 */
    private int capacity;
    
    /** 층 */
    private int floor;
    
    /** 호실 */
    private String number;
    
    /** 상태 */
    private String status;
    
    /** 설명 */
    private String description;

    /** 시설 목록 (폼 전송용) */
    private List<String> formFacilities;
    
    /** 시설 목록 (DB 저장용) */
    private List<FacilityVO> facilities;

    // Getter & Setter
    public int getRoomIdx() {
        return roomIdx;
    }

    public void setRoomIdx(int roomIdx) {
        this.roomIdx = roomIdx;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public int getFloor() {
        return floor;
    }

    public void setFloor(int floor) {
        this.floor = floor;
    }

    public String getNumber() {
        return number;
    }

    public void setNumber(String number) {
        this.number = number;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public List<String> getFormFacilities() {
        return formFacilities;
    }

    public void setFormFacilities(List<String> formFacilities) {
        this.formFacilities = formFacilities;
    }

    // Getter & Setter for facilities
    public List<FacilityVO> getFacilities() {
        return facilities;
    }

    public void setFacilities(List<FacilityVO> facilities) {
        this.facilities = facilities;
    }
    
    @Override
	public String toString() {
		return "RoomVO [roomIdx=" + roomIdx + ", name=" + name + ", capacity=" + capacity + ", floor=" + floor
				+ ", number=" + number + ", status=" + status + ", description=" + description + ", formFacilities="
				+ formFacilities + ", facilities=" + facilities + "]";
	}
}