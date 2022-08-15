clear all;
close all;

Number_Iteration=15000;
% magx_correction = 17.2200;
% magy_correction = 53.7900;
% magz_correction = -74.6500;

Data=zeros(Number_Iteration, 17);

% GyroscopeNoiseMPU9250 = 3.0462e-06; % GyroscopeNoise (variance value) in units of rad/s
% AccelerometerNoiseMPU9250 = 0.0061; % AccelerometerNoise(variance value)in units of m/s^2
 viewer = HelperOrientationViewer('Title',{'AHRS Filter'});
% FUSE = ahrsfilter('SampleRate',1000, 'GyroscopeNoise',GyroscopeNoiseMPU9250,'AccelerometerNoise',AccelerometerNoiseMPU9250);
% stopTimer = 100;



tcp_obj = tcpclient("192.168.1.64",80,"Timeout",10);
pause(2);


% f=figure;
% hold on;
% h1=plot(NaN,NaN,'-+b');
% h2=plot(NaN,NaN,'-+r');
% h3=plot(NaN,NaN,'-+g');

for i=1:Number_Iteration
    
  
    Line=tcp_obj.readline(); % main line to get the data from the ESP32
    if  ~isempty(Line)
        SplitLine=split(Line,",");
        
        Data(i,:)=str2double(SplitLine)';% Split and convert in number

        accel = [Data(i,3), Data(i,2), -Data(i,4)];
        gyro = [-Data(i,6), -Data(i,5), -Data(i,7)];
        %mag = [Data(i,8)- magx_correction, Data(i, 9) - magy_correction, Data(i,10) - magz_correction];
        mag = [Data(i,8), Data(i, 9), Data(i,10)];
       
        rotators = quaternion( Data(i,17),  Data(i,14),  Data(i,15),  Data(i,16));
        %rotators =FUSE(accel,gyro,mag);
    
        for j = numel(rotators)
            viewer(rotators(j));
  %          pause(0.01);
        end
        

%         accel = [-Data(i,3), -Data(i,2), Data(i,4)];
%         gyro = [Data(i,6), Data(i,5), -Data(i,7)];
%         mag = [Data(i,8)- magx_correction, Data(i, 9) - magy_correction, Data(i,10) - magz_correction];
%         
%        
%         rotators = FUSE(accel,gyro,mag);
%     
%         for j = numel(rotators)
%             viewer(rotators(j));
%             pause(0.01);
%         end
    end

end














% close all;
% %clear all;
%
% Data_XYZ=Data(:,2:end);% remove timestamp column 1
%
% figure
% grid on;
% hold on;
%
% plot3(Data_XYZ(:,1),Data_XYZ(:,2),Data_XYZ(:,3),'+b');
%
%
% magx_min = min(Data_XYZ(:,1));
% magx_max = max(Data_XYZ(:,1));
% magx_correction = (magx_max+magx_min)/2
%
%
% magy_min = min(Data_XYZ(:,2));
% magy_max = max(Data_XYZ(:,2));
% magy_correction = (magy_max+magy_min)/2
%
%
% magz_min = min(Data_XYZ(:,3));
% magz_max = max(Data_XYZ(:,3));
% magz_correction = (magz_max+magz_min)/2
%
% Data_XYZ_ManualCorrection_HardIron(:,1)=Data_XYZ(:,1) - magx_correction;
% Data_XYZ_ManualCorrection_HardIron(:,2)=Data_XYZ(:,2) - magy_correction;
% Data_XYZ_ManualCorrection_HardIron(:,3)=Data_XYZ(:,3) - magz_correction;
% plot3(Data_XYZ_ManualCorrection_HardIron(:,1),Data_XYZ_ManualCorrection_HardIron(:,2),Data_XYZ_ManualCorrection_HardIron(:,3),'r+');


%% using magcal hard + sodt iron

% [A,b,expmfs] = magcal(Data_XYZ)
%
% Data_XYZ_MagCal = (Data_XYZ-b)*A;
%
% plot3(Data_XYZ_MagCal(:,1),Data_XYZ_MagCal(:,2),Data_XYZ_MagCal(:,3),'+g');
%
% %% check with the ellispoid
%
% ellipsoid(0,0,0,expmfs,expmfs,expmfs);
