package egovframework.room.service;

public class UserVO extends UserDefaultVO {

    private static final long serialVersionUID = 1L;

    /** 사용자 인덱스 */
    private int userIdx;

    /** 아이디 */
    private String id;

    /** 이름 */
    private String name;

    /** 부서 인덱스 */
    private int departmentIdx;

    /** 전화번호 */
    private String phone;

    /** 이메일 */
    private String email;

    /** 비밀번호 */
    private String passwd;

    /** 부서명 (조인용) */
    private String departmentName;

    // Getter & Setter
    public int getUserIdx() {
        return userIdx;
    }

    public void setUserIdx(int userIdx) {
        this.userIdx = userIdx;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getDepartmentIdx() {
        return departmentIdx;
    }

    public void setDepartmentIdx(int departmentIdx) {
        this.departmentIdx = departmentIdx;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPasswd() {
        return passwd;
    }

    public void setPasswd(String passwd) {
        this.passwd = passwd;
    }

    public String getDepartmentName() {
        return departmentName;
    }

    public void setDepartmentName(String departmentName) {
        this.departmentName = departmentName;
    }
}