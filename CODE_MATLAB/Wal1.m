% Hàm Walsh bậc 1 (WAL(1, t))
% N = 2^n, n = 1 --> N = 2
% Hàm Walsh bậc 1 có giá trị +1 và -1 với điểm cắt qua trục 0 tại t = 0.

% Định nghĩa thời gian và tín hiệu
T = 1; % Chu kỳ của hàm Walsh
t = linspace(-4, 4, 1000); % Mảng thời gian từ -4 đến 4 với 1000 điểm

% Hàm Walsh bậc 1 với điểm cắt tại t = 0
wal_1 = ones(size(t)); % Khởi tạo mảng hàm Walsh bậc 1
wal_1(t >= 0) = -1; % Gán giá trị -1 cho nửa sau chu kỳ (t >= 0)

% Vẽ đồ thị của hàm Walsh
figure;
subplot(3,1,1);
plot(t, wal_1, 'LineWidth', 2);
title('Walsh Function WAL(1, t) with Zero Crossing at t = 0');
xlabel('Time (t)');
ylabel('WAL(1, t)');
grid on;
axis([-4 4 -1.5 1.5]);

% Tính Biến đổi Fourier (FFT)
N = length(wal_1); % Số mẫu của tín hiệu
fs = N / (t(end) - t(1)); % Tần số lấy mẫu

% Biến đổi Fourier nhanh (FFT) để tính phổ
WAL_1_fft = fft(wal_1);
WAL_1_fft = fftshift(WAL_1_fft); % Đưa tần số 0 về trung tâm

% Tính phổ biên độ (Magnitude Spectrum)
mag_spectrum = abs(WAL_1_fft);
% Tính phổ pha (Phase Spectrum)
phase_spectrum = angle(WAL_1_fft);

% Vẽ phổ biên độ
subplot(3,1,2);
f = fs * (-N/2:N/2-1) / N; % Tần số tương ứng
plot(f, mag_spectrum, 'LineWidth', 2);
title('Magnitude Spectrum of Walsh Function WAL(1, t)');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
grid on;

% Vẽ phổ pha
subplot(3,1,3);
plot(f, phase_spectrum, 'LineWidth', 2);
title('Phase Spectrum of Walsh Function WAL(1, t)');
xlabel('Frequency (Hz)');
ylabel('Phase (radians)');
grid on;
