DROP VIEW IF EXISTS view_khachhang_nu;
-- View 1: Danh sách khách hàng nữ (để phục vụ marketing và thống kê)
CREATE VIEW view_khachhang_nu AS
SELECT id, hoten, sdt
FROM khachhang
WHERE gioitinh = N'Nữ';

SELECT * FROM view_khachhang_nu;

-- View 2: Top thuốc bán chạy nhất(xem những thuốc bán chạy để ưu tiên nhập hàng)
CREATE VIEW view_top_thuoc_ban_chay AS
SELECT idthuoc, SUM(soluong) AS tongban
FROM ChiTietHoaDon
GROUP BY idthuoc
ORDER BY tongban DESC;

SELECT * FROM view_top_thuoc_ban_chay;

-- View 3: Doanh số bán hàng của từng nhân viên(theo dõi tổng doanh số mà mỗi nhân viên bán được)
CREATE VIEW view_doanhso_nhanvien AS
SELECT nv.idnv, nv.hoten, SUM(hd.tongtien) AS doanhso
FROM nhanvien nv
JOIN hoadon hd ON nv.idnv = hd.idnv
GROUP BY nv.idnv, nv.hoten;

SELECT * FROM view_doanhso_nhanvien;

-- View 4: Doanh thu mỗi ngày(phân tích doanh thu theo ngày)
CREATE VIEW view_doanhthu_theo_ngay AS
SELECT DATE(thoigiantao) AS ngay, SUM(tongtien) AS doanhthu
FROM hoadon
GROUP BY DATE(thoigiantao)
ORDER BY ngay;

SELECT * FROM view_doanhthu_theo_ngay;

-- View 5: Tồn kho thuốc(xem số lượng thuốc còn lại trong kho để nhập thêm hoặc xả hàng)
CREATE VIEW view_thuoc_ton_kho AS
SELECT ten, soluongton, giaban
FROM thuoc
ORDER BY soluongton DESC;

SELECT * FROM view_thuoc_ton_kho;


-- View 6: Số lần nhập hàng theo nhà cung cấp(thống kê mức độ hợp tác với nhà cung cấp)
CREATE VIEW view_nhacungcap_solan_nhap AS
SELECT ncc.tennhacungcap, COUNT(pn.idphieu) AS solan_nhaphang
FROM NhaCungCap ncc
LEFT JOIN phieunhaphang pn ON ncc.idncc = pn.idncc
GROUP BY ncc.tennhacungcap;

SELECT * FROM view_nhacungcap_solan_nhap;

--View 7:Hiển thị danh sách khách hàng, tổng tiền đã mua, số hóa đơn đã phát sinh và phân loại khách hàng theo mức độ chi tiêu:
CREATE VIEW v_thongke_khachhang AS
SELECT 
    kh.id AS makh,
    kh.hoten,
    COUNT(hd.idhd) AS sohoadon,
    SUM(ct.soluong * ct.dongia) AS tong_chi_tieu,
    CASE 
        WHEN SUM(ct.soluong * ct.dongia) > 500000 THEN 'VIP'
        WHEN SUM(ct.soluong * ct.dongia) BETWEEN 200000 AND 500000 THEN 'Thân thiết'
        ELSE 'Mới'
    END AS phanloai
FROM 
    khachhang kh
JOIN hoadon hd ON kh.id = hd.idkh
JOIN chitiethoadon ct ON hd.idhd = ct.idhd
GROUP BY 
    kh.id, kh.hoten
HAVING 
    COUNT(hd.idhd) >= 1
ORDER BY 
    tong_chi_tieu DESC;

SELECT * FROM v_thongke_khachhang;

--View 8: Hiển thị oanh thu từng hóa đơn, gồm tên khách, nhân viên và số tiền 
CREATE VIEW v_hoadon_doanhthu AS
SELECT 
    hd.idhd,
    kh.hoten AS ten_khachhang,
    nv.hoten AS ten_nhanvien,
    SUM(ct.soluong * ct.dongia) AS tong_doanhthu
FROM 
    hoadon hd
JOIN khachhang kh ON hd.idkh = kh.id
JOIN nhanvien nv ON hd.idnv = nv.idnv
JOIN chitiethoadon ct ON hd.idhd = ct.idhd
GROUP BY 
    hd.idhd, kh.hoten, nv.hoten;

Select * from v_hoadon_doanhthu;