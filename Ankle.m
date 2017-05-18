

a_ankle=0;
b_ankle=0;
c_ankle=0;
compteur_ankle=0;
sommet_plat_ankle=0;
moyenne_sommet_plat_ankle=0;
minima_plat_ankle=0;
moyenne_minima_plat_ankle=0;
ankleChangement = false;

BMI=(sub.weight)/(sub.height)^2;
l = length(time_vect);
answerFinale = zeros(1,l);



for i=1:l
    
    %% Left Ankle
    if i<700 %On suppose que le patient est sur du plat pendant au moins 7 sec
        a_ankle=a_ankle+left_ankle(i); % pour pouvoir calculer la valeur moyenne
        ankleChangement=true; % on est sur du plat
        if i>2 && left_ankle(i)<left_ankle(i-1) && left_ankle(i-1)>left_ankle(i-2)%si c'est un sommet
            b_ankle = b_ankle+1;
            sommet_plat_ankle(b_ankle)=left_ankle(i);%matrice avec vleur des sommets
        elseif i>2 && left_ankle(i)>left_ankle(i-1) && left_ankle(i-1)<left_ankle(i-2)%si c'est un minima
            c_ankle = c_ankle+1;
            minima_plat_ankle(c_ankle)=left_ankle(i);%matrice avec valeur des minima
        end
    elseif i==700
        a_ankle=(a_ankle+left_ankle(i))/700;%valeur moyenne plat
        answer_ankle=[1 1];
        moyenne_sommet_plat_ankle = mean(sommet_plat_ankle);%valeur moyenne sommets sur plat
        moyenne_minima_plat_ankle = mean(minima_plat_ankle);%valeur moyenne minima sur plat
        left_ankle_2 = (left_ankle-a_ankle)/(moyenne_sommet_plat_ankle-moyenne_minima_plat_ankle);%on normalise la fonction (? faire au fur et ? mesure dans la version finale!!!!!)
        figure
        plot(left_ankle_2)
        hold on
        line([1 l],[0.1 0.1],'Color','red')
        hold on
        line([1 l],[0.2 0.2],'Color','red')
        hold on
        line([1 l],[0.3 0.3],'Color','red')
        hold on
        line([1 l],[0.4 0.4],'Color','red')
        hold on
        line([1 l],[0.5 0.5],'Color','red')
        hold on
        line([1 l],[0.6 0.6],'Color','red')
        hold on
        line([1 l],[-0.1 -0.1],'Color','red')
        hold on
        line([1 l],[-0.2 -0.2],'Color','red')
        hold on
        line([1 l],[-0.3 -0.3],'Color','red')
        hold on
        line([1 l],[-0.4 -0.4],'Color','red')
        hold on
        line([1 l],[-0.5 -0.5], 'Color','red')
        title('left ankle')
        %moyenne_sommet_plat = 1;
        %moyenne_minima_plat = -1;
        
    elseif left_ankle_2(i)<left_ankle_2(i-1) && left_ankle_2(i-1)>left_ankle_2(i-4)%si on a un maximum
        if (BMI<21 && left_ankle_2(i)>0.84) || (sub.gender=='F' && left_ankle_2(i)>1.28) || (sub.gender=='M'&&BMI>21 && left_ankle_2(i)>0.65)
            %on est sur d'etre sur du plat ou descente
            ankleChangement=true;
        else
            % sinon on n'a pas de nouvelles infos
            compteur_ankle = 0;
        end
        %else answerl(i)=answerl(i-1);%si le max n'est pas entre ces valeur on ne peut d?terminer avec certitude -> comme avant
    end
    %else answerl(i) = answerl(i-1);
    
    %% AnswerFinale
    if ankleChangement
        answerFinale(i) = 1;
    
    else
        answerFinale(i)= 0;
    end
    ankleChangement=false;
end
figure
plot(time_vect,answerFinale*100, '.-b')
hold on
plot(time_vect,left_ankle, '--r')