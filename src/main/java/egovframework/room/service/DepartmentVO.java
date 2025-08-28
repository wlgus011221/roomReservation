package egovframework.room.service;

public class DepartmentVO extends DepartmentDefaultVO {

    private static final long serialVersionUID = 1L;

    /** 부서 인덱스 */
    private int departmentIdx;

    /** 부서명 */
    private String name;

    // Getter & Setter
    public int getDepartmentIdx() {
        return departmentIdx;
    }

    public void setDepartmentIdx(int departmentIdx) {
        this.departmentIdx = departmentIdx;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}