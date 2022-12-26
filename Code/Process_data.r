
df_loan <- read.csv("D:/Kì 1 - Năm học 2022-2023/Phân tích dữ liệu/DeTaiCuoiKy/loan_data_more.csv")

## Trích xuất các biến liên quan
#colnames(df_loan)
#str(df_loan)

# Xem tổng số biến của dataset
#ncol(df_loan)

# Xem tổng số hàng của dataset
#nrow(df_loan)

# Tổng cả 2
#dim(df_loan)

#
#
#---- Giải thích các cột # ----
#1 credit_policy: giá trị 1 nếu khách hàng đáp ứng đủ tiêu chí bảo lãnh tín dụng của LendingClub.com

#2 purpose: mục đích vay cho giáo dục, mua bán, kinh doanh nhỏ,...

#3 inrate: lãi suất của khoản vay, những người đi vay được đánh giá là rủi ro hơn sẽ được ấn định
#với mức lãi suất cao hơn

#4 installment: Khoản trả góp hàng tháng của người vay nếu khoản vay được chấp thuận

#5 log_annual_inc: Nhật ký tự báo cáo thu nhập hàng năm của người đi vay

#6 dti: Tỷ lệ nợ dựa trên thup nhập của người đi vay(số nợ/thu nhập hàng năm)

#7 fico: điểm tín dụng Fico của người vay(nhằm đánh giá rủi ro tín dụng và có nên gia hạn tín dụng
# hay không)

#8 days_with_cr_line: số ngày mà người vay đã có hạn mức tín dụng

#9 revol_bal: số dư quay vòng của người vay(số tiền chưa thanh toán vào cuối chu kỳ thanh toán
# thẻ tín dụng)

#10 revol_util: tỷ lệ sử dụng hạn mức quay vòng của người đi vay(số tiền của hạn mức tín dụng được
# sử dụng so với tổng tín dụng đang có)

#11 inq_last_6mths: Số lần người vay được các chủ nợ yêu cầu trong 6 tháng qua

#12 delinq_2yrs: Số lần người vay đã quá hạn thanh toán hơn 30 ngày trong vòng 2 năm

#13 pub_rec: Số lượng hồ sơ công khai xúc phạm người vay (hồ sơ phá sản, thế chấp thuế, bản án)

#14 not_fully_paid: giá trị 0 thể hiện khoản vay không được hoàn trả đầy đủ <> giá trị 1

## Kiểm tra sem dataset có giá trị trống hay không
#anyNA(df_loan)
# Tổng các giá trị trống trong dataset
#sum(is.na(df_loan))

# Có 146 giá trị trống chiếm 4% trong dataset, chúng ta có thể xóa mà không sợ ảnh hưởng
# đến toàn cục dữ liệu
df_loan = na.omit(df_loan)

# Kiểm tra lại xem còn sót giá trị trống nào không
sum(is.na(df_loan))

#---- Thống kê các số liệu liên quan--------
#str(df_loan)
#summary(df_loan)

# Lỗi cannot open the connection
# Fix tempdir() - > dir.create(tempdir()) trên console

### Thử nghiệm các mô hình hồi quy tuyến tính
#data = df_loan
# Sử dụng pairs để vẽ biểu đồ phân tán giữa các biến
#pairs(~not_fully_paid+log_annual_inc+inq_last_6mths+revol_bal,data = data)

# Ma trận tương quan giữa các biến
#cor(data[,c("not_fully_paid","log_annual_inc","inq_last_6mths","revol_bal")])

#----Forward Stepwise Selection#----

## Xác định mô hình chỉ chặn
#intercept_only <- lm(revol_bal ~ 1, data=data)
## Xác định mô hình với tất cả các biến dự đoán
#all <- lm(revol_bal ~ ., data=data)
## Thực hiện hồi quy từng bước
#forward <- step(intercept_only, direction='forward', scope=formula(all), trace=0)
## Xem kết quả của hồi quy từng bước
#forward$anova
## Xem mô hình cuối cùng
#forward$coefficients


#----Backward Stepwise Selection#----
## Xác định mô hình chỉ chặn
#intercept_only <- lm(revol_bal ~ 1, data=data)
## Xác định mô hình với tất cả các biến dự đoán
#all <- lm(revol_bal ~ ., data=data)
## Thực hiện hồi quy từng bước
#backward <- step(intercept_only, direction='backward', scope=formula(all), trace=0)
## Xem kết quả của hồi quy từng bước
#backward$anova
## Xem mô hình cuối cùng
#backward$coefficients

#----Both-Direction Stepwise Selection#----
## Xác định mô hình chỉ chặn
#intercept_only <- lm(revol_bal ~ 1, data=data)
## Xác định mô hình với tất cả các biến dự đoán
#all <- lm(revol_bal ~ ., data=data)
## Thực hiện hồi quy từng bước
#both <- step(intercept_only, direction='both', scope=formula(all), trace=0)
## Xem kết quả của hồi quy từng bước
#both$anova
## Xem mô hình cuối cùng
#both$coefficients

# So sanh mo hinh
#library("performance")
#model_performance(forward)
#model_performance(backward)
#model_performance(both)

# 
#table(df_loan$purpose)

## Mô hình hồi quy Logistic
## Chia bộ số liệu thành mẫu xây dựng và mẫu kiểm định
# library(caTools)
# set.seed(100)
# 
# split = sample.split(df_loan$not_fully_paid, SplitRatio = 0.65)
# 
# ## Chia mẫu train và test
# mauxaydung = subset(df_loan,split == TRUE)
# maukiemdinh =  subset(df_loan,split == FALSE)
# 
# ## Xây dựng mô hình logistic sử dụng tất cẩ các biến số
# model = glm(not_fully_paid ~ ., data = mauxaydung, family = binomial)
# summary(model)
# ## Dự báo trên bộ mẫu xây dựng
# dubaoxd = predict(model,type = "response",newdata = mauxaydung)
# summary(dubaoxd)
# ## Du bao tren bo mau kiem dinh
# dubaokd = predict(model,type = "response",newdata = maukiemdinh)
# # Xay dung ma tran nham lan voi muc nguong 0.5
# table(maukiemdinh$not_fully_paid,dubaokd > 0.5)
# ## Do chinh xac cua mo hinh
# (1221+8940)/nrow(maukiemdinh)
# ## Do chinh xac cua mo hinh co so
# (1221+2230)/nrow(maukiemdinh)
# 
# library(ROCR)
# # Phuong trinh du bao
# ROCRpred = prediction(dubaokd, maukiemdinh$not_fully_paid)
# # Ham thuc hien
# ROCRperf = performance(ROCRpred,"tpr","fpr")
# ## Ve duong ROC
# plot(ROCRperf)
# plot(ROCRperf,colorize = TRUE)
# plot(ROCRperf,colorize = TRUE,print.cutoffs.at = seq(0,1,by =0.1),text.adj = c(-0.2,1.7))
# 
# # CHi so AUC cho mau kiem dinh
# as.numeric(performance(ROCRpred,"auc")@y.values)

#names(table(df_loan$purpose))



