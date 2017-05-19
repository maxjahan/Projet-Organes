% l = length(left_ankle);
% answer = zeros(1,l); 
% 
% for i=2:l
%     if right_GRF(i)-right_GRF(i-1) <0 && mod(a,2)==0    
%         if left_ankle(i) < 90
%             answer(i) = 1;
%             a = 2;
%         end
%     elseif right_GRF(i)-right_GRF(i-1) <0 && mod(a,2)==0
%             if left_ankle(i) > 90
%                 answer(i) = 2;
%                 a=a+1;
%             end
%     elseif right_GRF(i)-right_GRF(i-1) <0 && mod(a,2)~=0
%                 answer(i) = answer(i-1);
% 
%     elseif right_GRF(i)-right_GRF(i-1) >0 && mod(a,2)~=0
%                 answer(i) = answer(i-1);
%                 a = a+1;
%     else
%         answer(i) = answer(i-1);
% 
%     end
% end
% plot(time_vect, answer)

% 
% a = right_hip';
% b = right_GRF';
% 
% CoefCorr = corr(a, b)


% sujet 2 %%
% left_ankle1 = left_ankle;
% left_hip1 = left_hip;
% left_knee1 = left_knee;
% right_GRF1 = right_GRF;
% right_hip1 = right_hip;
% time_vect1 = time_vect;
% true_manoeuvre1 = true_manoeuvre;

% 
% left_ankle1_100=left_ankle1(find(left_ankle1>100))
% left_ankle4_100=left_ankle4(find(left_ankle4>100))
% left_ankle7_100=left_ankle7(find(left_ankle7>100))

% matrice1 = [time_vect1; left_ankle1; left_hip1; left_knee1; right_GRF1; right_hip1; true_manoeuvre1];
% matrice4 = [time_vect4; left_ankle4; left_hip4; left_knee4; right_GRF4; right_hip4; true_manoeuvre4];
% matrice7 = [time_vect7; left_ankle7; left_hip7; left_knee7; right_GRF7; right_hip7; true_manoeuvre7];
% %matrice1(:,1)
% 
% matrice1_100 = matrice1(:,matrice1(4,:)<=90);
% matrice4_100 = matrice4(:,matrice4(4,:)<=90);
% matrice7_100 = matrice7(:,matrice7(4,:)<=90);
% 
% figure
% plot(matrice1_100(4,:))
% hold on
% plot(matrice4_100(4,:))
% hold on
% plot(matrice7_100(4,:))
% legend('sujet1', 'sujet2', 'sujet5')
% figure
% plot(matrice1_100(7,:), '-.')
% hold on
% plot(matrice4_100(7,:), '-')
% hold on
% plot(matrice7_100(7,:), '.')
% legend( 'true 1','true 4','true 7')
% figure
% plot(right_hip*1.72)
% figure
% plot(right_hip*sub.height)% 


%  figure 
%  movingAverage = conv(left_ankle, ones(101,1)/101, 'same');
%  plot(time_vect, movingAverage)
%  hold on
%  plot(time_vect,left_ankle)
%  title('movmean')

k=1;
q=150;
a=0;

l = length(time_vect);
movingMean = zeros(1, l-q);
movingSTD = zeros(1, l-q);
movingdiv = zeros(1, l-q);


for i= q+1:l
 movingMean(i-q) = mean(right_hip(i-q:i));
end

for i= q+1:l
 movingdiv(i-q) = std(right_hip(i-q:i))/mean(left_hip(i-q:i));
end

for i= q+1:l
 movingSTD(i-q) = std(right_hip(i-q:i));
end

figure
plot(movingMean-movingMean(1))
hold on
%line([1 l-q],[75 75],'Color','red') 
grid on
title('mean')
saveas(gcf,'movingMean_centre_droit_7.png')
figure
plot(movingSTD-movingSTD(1))
hold on
%line([1 l-q],[15 15],'Color','red')
grid on
title('standard dev')
saveas(gcf,'movingVariance_centre_droit_7.png')
figure
plot(movingdiv)
hold on
%line([1 l-q],[0.2 0.2],'Color','red')
grid on
title('standard dev/mean')
saveas(gcf,'movingDiv_centre_droit_7.png')
% figure
% plot(left_hip)

%plot(movingMean)

% for i = 1:length(movingMean)
%     if i<500 %On suppose que le patient est sur du plat pendant au moins 7 sec
%        a=a+movingMean(i); % pour pouvoir calculer la valeur moyenne
%        %answer(i)=1; % on est sur du plat
% 
%     elseif i==500
%             a=(a+movingMean(i))/500;%valeur moyenne plat
%             %answer(i)=1;
%             moyenne_sommet_plat = mean(sommet_plat);%valeur moyenne sommets sur plat
%             moyenne_minima_plat = mean(minima_plat);%valeur moyenne minima sur plat
%             movingMean2 = (movingMean-a)/(moyenne_sommet_plat-moyenne_minima_plat);%on normalise la fonction (à faire au fur et à mesure dans la version finale!!!!!)
%             figure
%             plot(movingMean2, 'g')
%             hold on
%             line([1 ll],[0.6 0.6],'Color','red') 
%             hold on
%             line([1 ll],[0.2 0.2],'Color','red') 
%             hold on
%             line([1 ll],[0.8 0.8],'Color','red') 
%             hold on
%             line([1 ll],[0.4 0.4],'Color','red')
%             hold on
%             line([1 ll],[1 1],'Color','red')
%             hold on
%             line([1 ll],[-0.6 -0.6],'Color','red') 
%             hold on
%             line([1 ll],[-0.2 -0.2],'Color','red') 
%             hold on
%             line([1 ll],[-0.8 -0.8],'Color','red') 
%             hold on
%             line([1 ll],[-0.4 -0.4],'Color','red')
%             hold on
%             line([1 ll],[-1 -1], 'Color','red')
%             hold on
%             line([1 ll],[-1.5 -1.5], 'Color','red')
%             hold on
%             line([1 ll],[-2 -2], 'Color','red')
%             title('left ankle moving mean')
%             axis([1 length(movingMean) -4 4])
%     end
% end
    
 
  % a =  sum(left_ankle(50:100))


    