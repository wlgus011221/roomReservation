package egovframework.room.web;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import egovframework.room.service.ReservationService;
import egovframework.room.service.ReservationVO;

@Controller
public class ExcelController {

	@Autowired
    private ReservationService reservationService;

    private static final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

    @GetMapping("/excelDownload.do")
    public void excelDownload(@RequestParam("date") String dateStr, HttpServletResponse response) throws IOException, Exception {
    	// 1. 해당 날짜의 예약 데이터 조회
        ReservationVO reservationVO = new ReservationVO();
        
        // 쿼리문의 WHERE 조건에 맞는 형식으로 날짜를 설정
        // 이 부분이 핵심! 쿼리문에 맞는 형식으로 문자열을 searchKeyword에 넣어줍니다.
        reservationVO.setSearchKeyword(dateStr); 

        reservationVO.setPageIndex(1);
        reservationVO.setRecordCountPerPage(Integer.MAX_VALUE); // 모든 데이터 가져오기

        List<ReservationVO> reservationList = reservationService.selectReservationListByDateNoPaging(reservationVO);
        
        // 2. 재사용 메소드 호출하여 엑셀 생성 및 전송
        String filename = "예약_리스트_" + dateStr + ".xlsx";
        createExcelAndSend(response, reservationList, "특정 날짜 예약 리스트", filename);
    }

    @GetMapping("/excelAllDownload.do")
    public void excelAllDownload(HttpServletResponse response) throws IOException, Exception {
        // 1. 모든 예약 데이터 조회
        ReservationVO reservationVO = new ReservationVO();
        List<ReservationVO> reservationList = reservationService.selectReservationList(reservationVO);

        // 2. 재사용 메소드 호출하여 엑셀 생성 및 전송
        String filename = "전체_회의실_예약_리스트.xlsx";
        createExcelAndSend(response, reservationList, "전체 예약 리스트", filename);
    }

    /**
     * 엑셀 파일을 생성하고 HTTP 응답으로 전송하는 재사용 메소드
     */
    private void createExcelAndSend(HttpServletResponse response, List<ReservationVO> list, String sheetName, String filename) throws IOException {
        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet(sheetName);

        // 헤더 생성
        String[] headers = {"회의실", "예약자", "제목", "시작 시간", "종료 시간"};
        Row headerRow = sheet.createRow(0);
        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
        }

        // 데이터 행 생성
        int rowNum = 1;
        for (ReservationVO res : list) {
            Row row = sheet.createRow(rowNum++);
            row.createCell(0).setCellValue(res.getRoomName());
            row.createCell(1).setCellValue(res.getUserName());
            row.createCell(2).setCellValue(res.getTitle());
            row.createCell(3).setCellValue(dateFormat.format(res.getStartDatetime()));
            row.createCell(4).setCellValue(dateFormat.format(res.getEndDatetime()));
        }

        // 응답 헤더 설정
        String encodedFilename = URLEncoder.encode(filename, StandardCharsets.UTF_8.toString()).replaceAll("\\+", "%20");
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment;filename=" + encodedFilename);

        // 엑셀 파일 전송
        workbook.write(response.getOutputStream());
        workbook.close();
    }
}