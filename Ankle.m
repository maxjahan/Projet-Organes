close all

a_ankle=0;
% b_ankle=0;
% c_ankle=0;
% compteur_ankle=0;
sommet_plat_ankle=0;
% moyenne_sommet_plat_ankle=0;
% minima_plat_ankle=0;
% moyenne_minima_plat_ankle=0;
% ankleIsNot2 = false;
% ankleIs3 = false;
% 
sommet_plat_ankle_max=0;
sommet_plat_ankle_min=2000;
% 
BMI=(sub.weight)/(sub.height)^2;
% l = length(time_vect);
answerFinale = zeros(1,l);



% for i=1:l
    % Left Ankle
    %     if i<700 %On suppose que le patient est sur du plat pendant au moins 7 sec
    %         a_ankle=a_ankle+left_ankle(i); % pour pouvoir calculer la valeur moyenne
    %         ankleChangement=true; % on est sur du plat
    %         if i>2 && left_ankle(i)<left_ankle(i-1) && left_ankle(i-1)>left_ankle(i-2)%si c'est un sommet
    %             b_ankle = b_ankle+1;
    %             sommet_plat_ankle(b_ankle)=left_ankle(i);%matrice avec vleur des sommets
    %         elseif i>2 && left_ankle(i)>left_ankle(i-1) && left_ankle(i-1)<left_ankle(i-2)%si c'est un minima
    %             c_ankle = c_ankle+1;
    %             minima_plat_ankle(c_ankle)=left_ankle(i);%matrice avec valeur des minima
    %         end
    %     elseif i==700
    %         a_ankle=(a_ankle+left_ankle(i))/700;%valeur moyenne plat
    %         answer_ankle=[1 1];
    %         moyenne_sommet_plat_ankle = mean(sommet_plat_ankle);%valeur moyenne sommets sur plat
    %         moyenne_minima_plat_ankle = mean(minima_plat_ankle);%valeur moyenne minima sur plat
    %         left_ankle_2 = (left_ankle-a_ankle)/(moyenne_sommet_plat_ankle-moyenne_minima_plat_ankle);%on normalise la fonction (? faire au fur et ? mesure dans la version finale!!!!!)
    %         figure
    %         plot(left_ankle_2)
    %         hold on
    %         line([1 l],[0.1 0.1],'Color','red')
    %         hold on
    %         line([1 l],[0.2 0.2],'Color','red')
    %         hold on
    %         line([1 l],[0.3 0.3],'Color','red')
    %         hold on
    %         line([1 l],[0.4 0.4],'Color','red')
    %         hold on
    %         line([1 l],[0.5 0.5],'Color','red')
    %         hold on
    %         line([1 l],[0.6 0.6],'Color','red')
    %         hold on
    %         line([1 l],[-0.1 -0.1],'Color','red')
    %         hold on
    %         line([1 l],[-0.2 -0.2],'Color','red')
    %         hold on
    %         line([1 l],[-0.3 -0.3],'Color','red')
    %         hold on
    %         line([1 l],[-0.4 -0.4],'Color','red')
    %         hold on
    %         line([1 l],[-0.5 -0.5], 'Color','red')
    %         title('left ankle')
    %         %moyenne_sommet_plat = 1;
    %         %moyenne_minima_plat = -1;
    %
    %     elseif left_ankle_2(i)<left_ankle_2(i-1) && left_ankle_2(i-1)>left_ankle_2(i-4)%si on a un maximum
    %         if (sub.gender=='M' && BMI<21 && left_ankle_2(i)>0.84) || (sub.gender=='F' && left_ankle_2(i)>1.28) || (sub.gender=='M'&&BMI>21 && left_ankle_2(i)>0.65)
    %             %on est sur d'etre sur du plat ou descente
    %             ankleChangement=true;
    %         else
    %             % sinon on n'a pas de nouvelles infos
    %             compteur_ankle = 0;
    %         end
    %         %else answerl(i)=answerl(i-1); %si le max n'est pas entre ces valeur on ne peut d?terminer avec certitude -> comme avant
    
%     if i<700 %On suppose que le patient est sur du plat pendant au moins 7 sec
%         a_ankle=a_ankle+left_ankle(i); % pour pouvoir calculer la valeur moyenne
%         ankleIsNot2=true; % on est sur du plat
%         if left_ankle(i)>sommet_plat_ankle_max
%             sommet_plat_ankle_max = left_ankle(i);
%         elseif left_ankle(i)<sommet_plat_ankle_min
%             sommet_plat_ankle_min = left_ankle(i);
%         end
%     elseif i==700
%         a_ankle=(a_ankle+left_ankle(i))/700;%valeur moyenne plat
%         ankleIsNot2=true;
%         left_ankle_2 = (left_ankle-a_ankle)/(sommet_plat_ankle_max-sommet_plat_ankle_min);%on normalise la fonction (? faire au fur et ? mesure dans la version finale!!!!!)
%         figure
%         plot(left_ankle_2)
%         title('left ankle-2')
%     elseif left_ankle_2(i)<left_ankle_2(i-1) && left_ankle_2(i-1)>left_ankle_2(i-4)%si on a un maximum
%         if (sub.gender=='M' && BMI<21 && left_ankle_2(i)>0.84) || (sub.gender=='F' && left_ankle_2(i)>1.28) || (sub.gender=='M'&&BMI>21 && left_ankle_2(i)>0.65)
%             %on est sur d'etre sur du plat ou descente
%             ankleIsNot2=true;
%         else
%             % sinon on n'a pas de nouvelles infos
%             compteur_ankle = 0;
%         end
%     elseif std(left_ankle_2(i-150:i))*BMI- std(left_ankle_2(1:150))*BMI > 2.1
%         %         if answerFinale(i-1) == 2 && compteur <100 %ne peut pas redescendre dans la seconde quand il est sur du plat
%         %             compteur_ankle = compteur_ankle+1;
%         %         else
%         %             ankleIs3 = true;
%         %             compteur_ankle = 0;
%         %         end
%         ankleIs3=true;
%     end
%     %else answerl(i) = answerl(i-1);
% end
%% variables communes %%
l = length(time_vect);
answerFinale1 = zeros(1,l); % vecteur contenant la reponse pour chaque instant
answerFinale2 = zeros(1,l);

%% variables ANKLE %%
answerAnkle = zeros(1,2);
maxInstantA = zeros(1,l);
minInstantA = zeros(1,l);
compteur2A = 0;
compteur3A = 0;


%% Code %%

for i=1:l
    if i<150 %On suppose que le patient est sur du plat pendant au moins 1,5 sec
        a_ankle=a_ankle+left_ankle(i); % pour pouvoir calculer la valeur moyenne
        ankleIsNot2=true; % on est sur du plat
        answer_ankle = [1 0];
        if left_ankle(i)>sommet_plat_ankle_max
            sommet_plat_ankle_max = left_ankle(i);
        elseif left_ankle(i)<sommet_plat_ankle_min
            sommet_plat_ankle_min = left_ankle(i);
        end
    elseif i==150
        a_ankle=(a_ankle+left_ankle(i))/150;%valeur moyenne plat
        answer_ankle = [1 0];
        left_ankle_2 = (left_ankle-a_ankle)/(sommet_plat_ankle_max-sommet_plat_ankle_min);%on normalise la fonction
        
    elseif left_ankle_2(i)<left_ankle_2(i-1) && left_ankle_2(i-1)>left_ankle_2(i-2)%si on a un maximum
        if (sub.gender=='M' && BMI<21 && left_ankle_2(i)>0.84) || (sub.gender=='F' && left_ankle_2(i)>1.28) || (sub.gender=='M'&& BMI>21 && left_ankle_2(i)>0.75)
            answer_ankle = [1 3]; %on est sur d'etre sur du plat ou descente
        else
            compteur_ankle = 0; %sinon on n'a pas de nouvelles infos
        end
    end
    
    %% AnswerFinale
    if answer_ankle == [1 3]
        answerFinale2(i)= 1;
    end
end

figure
plot(time_vect,answerFinale2, '.-b')
hold on
plot(time_vect,true_manoeuvre, '--r')
legend('AnkleIsNot2','Donnee');

% q = 150;
% l = length(time_vect);
% movingSTD = zeros(1, l-q);
% for p= q+1:l
%     movingSTD(p-q) = std(left_ankle_2(p-q:p))*BMI;
% end
% figure
% plot(time_vect(151:end),movingSTD-movingSTD(1))
% hold on
% plot(time_vect,true_manoeuvre, '--r')
% %line([1 l-q],[15 15],'Color','red')
% grid on
% title('standard dev')