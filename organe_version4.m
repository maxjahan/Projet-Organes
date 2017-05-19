%code sans long vecteur sauf le final ou on analyse donn�e par donn�e et on
%donne une valeur � cette donn�e.

%Hypoth�ses: -pendant les 7 premi�res secondes au moins, il est sur du plat
%            - Il y a au moins une seconde de marche entre une mont�e et
%            une descente
%Algo: on calcul la valeur moyenne de l'angle de la hanche sur du plat
%pendant les 7 premi�re secondes. On normalise pour que les cycles sur plat
%soient compris entr -1 et 1.
%Ensuite, en analysant les �cart des pics par rapport � cette valeur moyenne, on d�termine sur quel type de
%terrain on se trouve (plat, escaliers en mont�e, escaliers en descente).
close all


BMI = sub.weight/(sub.height)^2;
l = length(time_vect);

k=1;
a=0;
b=0; %compteur minima
c=0; %compteur maxima
compteur = 0;%calcule de temps
compteur2 = 0;

sommet_plat_max=0;
sommet_plat_min=2000;

al=0;
bl=0; %compteur minima
cl=0; %compteur maxima
compteurl = 0;%calcule de temps
compteur2l = 0;
%answerl = zeros(1,l);
sommet_plat_maxl=0;
sommet_plat_minl=2000;

a_ankle=0;
b_ankle=0;
c_ankle=0;
compteur_ankle=0;
sommet_plat_ankle=0;
moyenne_sommet_plat_ankle=0;
minima_plat_ankle=0;
moyenne_minima_plat_ankle=0;
% compteur_ankle2=0;
% sommet_plat_ankle_min=2000;
% sommet_plat_ankle_max=0;
% moyenne_sommet_plat_ankle=0;


answer_hanche_g = 0;
answer_hanche_d = 0;
kneeChangement=false;
ankleChangement = false;

answerFinale = zeros(1,l);

for i=1:l
    
    %% Hanche Droite
    
    if i<700 %On suppose que le patient est sur du plat pendant au moins 7 sec
        a=a+right_hip(i); % pour pouvoir calculer la valeur moyenne
        answer_hanche_d=1; % on est sur du plat
        if right_hip(i)>sommet_plat_max
            sommet_plat_max = right_hip(i);
        elseif right_hip(i)<sommet_plat_min
            sommet_plat_min = right_hip(i);
        end
    elseif i==700
        a=(a+right_hip(i))/700;%valeur moyenne plat
        answer_hanche_d=1;
        right_hip_2 = (right_hip-a)/(sommet_plat_max-sommet_plat_min);%on normalise la fonction (� faire au fur et � mesure dans la version finale!!!!!)
        plot(right_hip_2)
    elseif right_hip_2(i) > 0.3
        answer_hanche_d = 1;
    elseif right_hip_2(i) < -0.8
        if answer_hanche_d == 3 && compteur2 < 100
            compteur2 = compteur2+1;
        else
            answer_hanche_d = 2;
            compteur2 = 0;
        end
    elseif std(right_hip_2(i-150:i))*BMI - std(right_hip_2(1:150))*BMI < -2
        if answer_hanche_d == 2 && compteur <100
            compteur = compteur+1;
        else
            answer_hanche_d = 3;
            compteur = 0;
        end
    end
    
    %% Hanche Gauche
    
    if i<700 %On suppose que le patient est sur du plat pendant au moins 7 sec
        al=al+left_hip(i); % pour pouvoir calculer la valeur moyenne
        answer_hanche_g=1; % on est sur du plat
        if left_hip(i)>sommet_plat_maxl
            sommet_plat_maxl = left_hip(i);
        elseif left_hip(i)<sommet_plat_minl
            sommet_plat_minl = left_hip(i);
        end
    elseif i==700
        al=(al+left_hip(i))/700;%valeur moyenne plat
        answer_hanche_g=1;
        left_hip_2 = (left_hip-a)/(sommet_plat_maxl-sommet_plat_minl);%on normalise la fonction (� faire au fur et � mesure dans la version finale!!!!!)
        figure
        plot(left_hip_2)
        title('left_hip-2')
    elseif left_hip_2(i) > 0.3
        answer_hanche_g = 1;
    elseif left_hip_2(i) < -0.6
        if answer_hanche_g == 3 && compteur2l < 100
            compteur2l = compteur2l+1;
        else
            answer_hanche_g = 2;
            compteur2l = 0;
        end
    elseif std(left_hip_2(i-150:i))*BMI- std(left_hip_2(1:150))*BMI < -4
        if answer_hanche_g == 2 && compteur <100
            compteurl = compteurl+1;
        else
            answer_hanche_g = 3;
            compteurl = 0;
        end
    end
    
    %% Ankle
    if i<700 %On suppose que le patient est sur du plat pendant au moins 7 sec
        a_ankle=a_ankle+left_ankle(i); % pour pouvoir calculer la valeur moyenne
        ankleChangement=true; % on est sur du plat
        if i>2 && left_ankle(i)<left_ankle(i-1) && left_ankle(i-1)>left_ankle(i-2)%si c'est un sommet
            b_ankle = b_ankle+1;
            sommet_plat_ankle(b_ankle)=left_ankle(i);%matrice avec valeur des sommets
        elseif i>2 && left_ankle(i)>left_ankle(i-1) && left_ankle(i-1)<left_ankle(i-2)%si c'est un minima
            c_ankle = c_ankle+1;
            minima_plat_ankle(c_ankle)=left_ankle(i);%matrice avec valeur des minima
        end
    elseif i==700
        a_ankle=(a_ankle+left_ankle(i))/700;%valeur moyenne plat
        ankleChangement=true;
        moyenne_sommet_plat_ankle = mean(sommet_plat_ankle);%valeur moyenne sommets sur plat
        moyenne_minima_plat_ankle = mean(minima_plat_ankle);%valeur moyenne minima sur plat
        left_ankle_2 = (left_ankle-a_ankle)/(moyenne_sommet_plat_ankle-moyenne_minima_plat_ankle);%on normalise la fonction (? faire au fur et ? mesure dans la version finale!!!!!)
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
       
    elseif left_ankle_2(i)<left_ankle_2(i-1) && left_ankle_2(i-1)>left_ankle_2(i-4)%si on a un maximum
        if (BMI<21 && left_ankle_2(i)>0.84) || (sub.gender=='F' && left_ankle_2(i)>1.28) || (sub.gender=='M'&&BMI>21 && left_ankle_2(i)>0.65)
            %on est sur d'etre sur du plat ou descente
            ankleChangement=true;
        else
            % sinon on n'a pas de nouvelles infos
            compteur_ankle = 0;
        end
        
        
    end
    %
    %     if i<700 %On suppose que le patient est sur du plat pendant au moins 7 sec
    %        a_ankle=a_ankle+left_ankle(i); % pour pouvoir calculer la valeur moyenne
    %        ankleChangement=true; % on est sur du plat
    %        if left_ankle(i)>sommet_plat_ankle_max
    %            sommet_plat_ankle_max = left_ankle(i);
    %        elseif left_ankle(i)<sommet_plat_ankle_min
    %            sommet_plat_ankle_min = left_ankle(i);
    %        end
    %     elseif i==700
    %             a_ankle=(a_ankle+left_ankle(i))/700;%valeur moyenne plat
    %             ankleChangement=true;
    %             left_ankle_2 = (left_ankle-a)/(sommet_plat_ankle_max-sommet_plat_ankle_min);%on normalise la fonction (� faire au fur et � mesure dans la version finale!!!!!)
    %             figure
    %             plot(left_ankle_2)
    %             title('left_ankle-2')
    %     elseif left_ankle_2(i) > 0.3
    %         ankleChangement = true;
    %     elseif left_ankle_2(i) < -0.6
    %         if ankleChangement == 3 && compteur_ankle2 < 100
    %             compteur_ankle2 = compteur_ankle2+1;
    %         else
    %             ankleChangement = 2;
    %             compteur_ankle2 = 0;
    %         end
    %     elseif std(left_ankle_2(i-150:i))*BMI- std(left_ankle_2(1:150))*BMI < -4
    %         if ankleChangement == 2 && compteur <100
    %             compteur_ankle = compteur_ankle+1;
    %         else
    %             ankleChangement = 3;
    %             compteur_ankle = 0;
    %         end
    %     end
    %% Genou Gauche
    
    if i>700
        if left_knee(i)>left_knee(i-k) && left_knee(i-k)<left_knee(i-2*k)% si on a un minime
            if left_knee(i) <110 % plus petit que 110
                kneeChangement=true;
            end
        end
    end
    
    
    
    
    %% AnswerFinale
    
    answer = [answer_hanche_g answer_hanche_d];
    if kneeChangement
        answer = [answer 2 3];
    end
    if ankleChangement
        answer = [answer 1 3];
        ankleChangement=false;
        
    end
    countOne = sum(answer==1);
    countTwo = sum(answer==2);
    countThree=sum(answer==3);
    Combine=[countOne countTwo countThree];
    maxval= max(Combine);
    idx = find(Combine == maxval);
    
    if length(idx) >1
        answerFinale(i) = answerFinale(i-1);
        
    else answerFinale(i) = mode(answer);
    end
end
figure
plot(time_vect,answerFinale, '.-b')
hold on
plot(time_vect,true_manoeuvre, '--r')
%figure
%plot(right_hip)

q = 150;
l = length(time_vect);
movingSTD = zeros(1, l-q);
for p= q+1:l
    movingSTD(p-q) = std(left_hip_2(p-q:p))*BMI;
end
figure
plot(movingSTD-movingSTD(1))
hold on
%line([1 l-q],[15 15],'Color','red')
grid on
title('standard dev')

for p= q+1:l
    movingSTD(p-q) = std(right_hip_2(p-q:p))*BMI;
end
figure
plot(movingSTD-movingSTD(1))
hold on
%line([1 l-q],[15 15],'Color','red')
grid on
title('standard dev')