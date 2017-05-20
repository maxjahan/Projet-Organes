%code sans long vecteur sauf le final ou on analyse donnée par donnée et on
%donne une valeur à cette donnée.

%Hypothèses: -pendant les 7 premières secondes au moins, il est sur du plat
%            - Il y a au moins une seconde de marche entre une montée et
%            une descente 
%Algo: on calcul la valeur moyenne de l'angle de la hanche sur du plat
%pendant les 7 première secondes. On normalise pour que les cycles sur plat
%soient compris entr -1 et 1.
%Ensuite, en analysant les écart des pics par rapport à cette valeur moyenne, on détermine sur quel type de
%terrain on se trouve (plat, escaliers en montée, escaliers en descente).
close all


BMI = sub.weight/(sub.height);


k=1;
a=0;
b=0; %compteur minima
c=0; %compteur maxima
compteur = 0;%calcule de temps
compteur2 = 0;
l = length(time_vect);
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

answer_hanche_g = 0;
answer_hanche_d = 0;
answer_knee= [0 0];


answerFinale = zeros(1,l);

for i=1:l
    
    %% Hanche Droite
    
    if i<150 %On suppose que le patient est sur du plat pendant au moins 7 sec
       a=a+right_hip(i); % pour pouvoir calculer la valeur moyenne
       answer_hanche_d=1; % on est sur du plat
       if right_hip(i)>sommet_plat_max
           sommet_plat_max = right_hip(i);
       elseif right_hip(i)<sommet_plat_min
           sommet_plat_min = right_hip(i);
       end
    elseif i==150
            a=(a+right_hip(i))/150;%valeur moyenne plat
            answer_hanche_d=1;
            right_hip_2 = (right_hip-a)/(sommet_plat_max-sommet_plat_min);%on normalise la fonction (à faire au fur et à mesure dans la version finale!!!!!)
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
            left_hip_2 = (left_hip-a)/(sommet_plat_maxl-sommet_plat_minl);%on normalise la fonction (à faire au fur et à mesure dans la version finale!!!!!)
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
   
   
   %% Genou Gauche
   
  if i>700 
    if left_knee(i)>left_knee(i-k) && left_knee(i-k)<left_knee(i-2*k)% si on a un minime
        if left_knee(i) <110 % plus petit que 110
            answer_knee = [2 3];
        else answer_knee = [0 0];
        end
    end
  end
   
   
   
   %% AnswerFinale
       
    if answer_knee(1) == 2  && answer_knee(2) == 3
    answer = [answer_hanche_g answer_hanche_d answer_knee];
    answerFinale(i) = mode(answer)  ;
    else 
        if answer_hanche_g==answer_hanche_d
            answerFinale(i) = answer_hanche_g;
        else answerFinale(i) = answerFinale(i-1);
        end
    end
end
figure
plot(time_vect,answerFinale, '.-b')
hold on
plot(time_vect,true_manoeuvre, '--r')

%figure 
%plot(right_hip)

% q = 150;
% l = length(time_vect);
% movingSTD = zeros(1, l-q);
% for p= q+1:l
%  movingSTD(p-q) = std(left_hip_2(p-q:p))*BMI;
% end
% figure
% plot(movingSTD-movingSTD(1))
% hold on
% %line([1 l-q],[15 15],'Color','red')
% grid on
% title('standard dev')
% 
% for p= q+1:l
%  movingSTD(p-q) = std(right_hip_2(p-q:p))*BMI;
% end
% figure
% plot(movingSTD-movingSTD(1))
% hold on
% %line([1 l-q],[15 15],'Color','red')
% grid on
% title('standard dev')

Pourcent = ((sum(answerFinale-true_manoeuvre==0))/length(true_manoeuvre))*100