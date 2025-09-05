package egovframework.room.service;

public class FacilityVO {

    private static final long serialVersionUID = 1L;
    
    /** 시설 인덱스 */
    private int facilityIdx;
    
    /** 시설명 */
    private String name;
    
    // Getter & Setter
    public int getFacilityIdx() {
        return facilityIdx;
    }

    public void setFacilityIdx(int facilityIdx) {
        this.facilityIdx = facilityIdx;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
    
    @Override
	public String toString() {
		return "FacilityVO [facilityIdx=" + facilityIdx + ", name=" + name + "]";
	}
}