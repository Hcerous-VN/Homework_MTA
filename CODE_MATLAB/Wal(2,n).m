% Định nghĩa miền thời gian từ -4 đến 4
t = linspace(-4, 4, 1000);  % Tạo một vector thời gian từ -4 đến 4, với 1000 điểm

% Hàm Walsh bậc 3 với các giá trị +1 và -1 phân bố đều trong khoảng thời gian từ -4 đến 4
W_2 = ones(size(t));   % Khởi tạo một vector chứa toàn bộ giá trị +1

% Thay đổi giá trị thành -1 theo các đoạn thời gian sao cho giá trị lần lượt là 1, -1, -1, 1 cách đều
W_2(t >= -4 & t < -2) = 1;   % Thay đổi giá trị thành +1 trong khoảng từ -4 đến -2
W_2(t >= -2 & t < 0) = -1;   % Thay đổi giá trị thành -1 trong khoảng từ -2 đến 0
W_2(t >= 0 & t < 2) = -1;    % Thay đổi giá trị thành -1 trong khoảng từ 0 đến 2
W_2(t >= 2 & t < 4) = 1;     % Thay đổi giá trị thành +1 trong khoảng từ 2 đến 4

% Vẽ đồ thị của hàm Walsh
figure;
subplot(3,1,1);
plot(t, W_2, 'LineWidth', 2);
title('Hàm Walsh bậc 2 WAL(2,t) ');
xlabel('t');
ylabel('W_2(t)');
ylim([-2 2]);  % Đặt giới hạn trục tung từ -2 đến 2
grid on;

% Tính và vẽ phổ biên độ
N = length(t);  % Số lượng điểm
Fs = N / (t(end) - t(1));  % Tần số lấy mẫu
W_3_fft = fft(W_2);  % Phép biến đổi Fourier

% Tính phổ biên độ
W_3_magnitude = abs(W_3_fft);
f = Fs * (0:(N/2)) / N;  % Tạo trục tần số

% Lấy một nửa phổ (do phổ Fourier là đối xứng)
W_3_magnitude_half = W_3_magnitude(1:N/2+1);

subplot(3,1,2);
plot(f, W_3_magnitude_half, 'LineWidth', 2);
title('Phổ Biên Độ của Hàm Walsh');
xlabel('Tần số (Hz)');
ylabel('Biên độ');
grid on;

% Tính và vẽ phổ pha
W_2_phase = angle(W_3_fft);  % Phổ pha

% Lấy một nửa phổ pha
W_2_phase_half = W_2_phase(1:N/2+1);

subplot(3,1,3);
plot(f, W_2_phase_half, 'LineWidth', 2);
title('Phổ Pha của Hàm Walsh');
xlabel('Tần số (Hz)');
ylabel('Pha (radian)');
grid on;