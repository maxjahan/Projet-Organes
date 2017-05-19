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
close all;
a=0;
b=0; %compteur minima
c=0; %compteur maxima
compteur = 0;%calcule de temps
l = length(time_vect);
%answer = zeros(1,l);
sommet_plat=0;
moyenne_sommet_plat=0;
minima_plat=0;
moyenne_minima_plat=0;

al=0;
bl=0; %compteur minima
cl=0; %compteur maxima
compteurl = 0;%calcule de temps
ll = length(time_vect);
%answerl = zeros(1,l);
sommet_platl=0;
moyenne_sommet_platl=0;
minima_platl=0;
moyenne_minima_platl=0;

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

kneeChangement = false;

answer_hanche_g = 0;
answer_hanche_d = 0;


answerFinale = zeros(1,l);

for i=1:l
    
    %% Hanche Droite
    
    if i<700 %On suppose que le patient est sur du plat pendant au moins 7 sec
        a=a+right_hip(i); % pour pouvoir calculer la valeur moyenne
        answer_hanche_d=1; % on est sur du plat
        if i>2 && right_hip(i)<right_hip(i-1) && right_hip(i-1)>right_hip(i-2)%si c'est un sommet
            b = b+1;
            sommet_plat(b)=right_hip(i);%matrice avec vleur des sommets
        elseif i>2 && right_hip(i)>right_hip(i-1) && right_hip(i-1)<right_hip(i-2)%si c'est un minima
            c = c+1;
            minima_plat(c)=right_hip(i);%matrice avec valeur des minima
        end
    elseif i==700
        a=(a+right_hip(i))/700;%valeur moyenne plat
        answer_hanche_d=1;
        moyenne_sommet_plat = mean(sommet_plat);%valeur moyenne sommets sur plat
        moyenne_minima_plat = mean(minima_plat);%valeur moyenne minima sur plat
        right_hip_2 = (right_hip-a)/(moyenne_sommet_plat-moyenne_minima_plat);%on normalise la fonction (à faire au fur et à mesure dans la version finale!!!!!)
     
    elseif right_hip_2(i)>right_hip_2(i-1) && right_hip_2(i-1)<right_hip_2(i-2)% sinon c'est un minima
        if right_hip_2(i)<-1.8 % et qu'il est plsu petit que -1.8
            answer_hanche_d=2;% on est sur d'être en montée
            %else answer(i) = answer(i-1);% sin le minima est ailleur on ne peut déterminer ou on se trouve donc on suppose que la situaion est la même qu'avant.
        end
    elseif right_hip_2(i)<right_hip_2(i-1) && right_hip_2(i-1)>right_hip_2(i-4)%si on a un maxima
        if right_hip_2(i)>0.8%et qu'il est plus grand que 0.8
            answer_hanche_d=1;%on est sur d'être sur du plat
            %sommet_plat(i)=right_hip(i);
            %moyenne_sommet_plat = mean(sommet_plat);
        elseif right_hip_2(i)<0.7 && right_hip_2(i)>-0.3 %si le sommet est par contre situé entre 0.7 et -0.3 (à optimiser)
            if answerFinale(i-1)==2 && compteur <= 100 % si avant on montait
                compteur= compteur +1;
                %answer(i) = answer(i-1); % on suppose qu'on ne descend pas directement après et qu'il y a au moins une sec entre les deux
            else
                answer_hanche_d=3; % sinon on descend
                compteur = 0;
            end
            %else answer(i)=answer(i-1);%si le max n'est pas entre ces valeur on ne peut déterminer avec certitude -> comme avant
        end
        %else answer(i) = answer(i-1);% idem
    end
    
    %% Hanche Gauche
    
    
    if i<700 %On suppose que le patient est sur du plat pendant au moins 7 sec
        al=al+left_hip(i); % pour pouvoir calculer la valeur moyenne
        answer_hanche_g=1; % on est sur du plat
        if i>2 && left_hip(i)<left_hip(i-1) && left_hip(i-1)>left_hip(i-2)%si c'est un sommet
            bl = bl+1;
            sommet_platl(bl)=left_hip(i);%matrice avec vleur des sommets
        elseif i>2 && left_hip(i)>left_hip(i-1) && left_hip(i-1)<left_hip(i-2)%si c'est un minima
            cl = cl+1;
            minima_platl(cl)=left_hip(i);%matrice avec valeur des minima
        end
    elseif i==700
        al=(al+left_hip(i))/700;%valeur moyenne plat
        answer_hanche_g=1;
        moyenne_sommet_platl = mean(sommet_platl);%valeur moyenne sommets sur plat
        moyenne_minima_platl = mean(minima_platl);%valeur moyenne minima sur plat
        left_hip_2 = (left_hip-al)/(moyenne_sommet_platl-moyenne_minima_platl);%on normalise la fonction (à faire au fur et à mesure dans la version finale!!!!!)
        %             figure
        %             plot(left_hip_2)
        %             hold on
        %             line([1 ll],[0.1 0.1],'Color','red')
        %             hold on
        %             line([1 ll],[0.2 0.2],'Color','red')
        %             hold on
        %             line([1 ll],[0.3 0.3],'Color','red')
        %             hold on
        %             line([1 ll],[0.4 0.4],'Color','red')
        %             hold on
        %             line([1 ll],[0.5 0.5],'Color','red')
        %             hold on
        %             line([1 ll],[-0.1 -0.1],'Color','red')
        %             hold on
        %             line([1 ll],[-0.2 -0.2],'Color','red')
        %             hold on
        %             line([1 ll],[-0.3 -0.3],'Color','red')
        %             hold on
        %             line([1 ll],[-0.4 -0.4],'Color','red')
        %             hold on
        %             line([1 ll],[-0.5 -0.5], 'Color','red')
        %             title('left hip')
        %moyenne_sommet_plat = 1;
        %moyenne_minima_plat = -1;
    elseif left_hip_2(i)>left_hip_2(i-1) && left_hip_2(i-1)<left_hip_2(i-2)% sinon c'est un minima
        if left_hip_2(i)<-1.25 % et qu'il est plsu petit que -1.8
            answer_hanche_g=2;% on est sur d'être en montée
            %else answerl(i) = answerl(i-1);% sin le minima est ailleur on ne peut déterminer ou on se trouve donc on suppose que la situaion est la même qu'avant.
        end
    elseif left_hip_2(i)<left_hip_2(i-1) && left_hip_2(i-1)>left_hip_2(i-4)%si on a un maxima
        if left_hip_2(i)>0.4%et qu'il est plus grand que 0.8
            answer_hanche_g=1;%on est sur d'être sur du plat
            %sommet_plat(i)=right_hip(i);
            %moyenne_sommet_plat = mean(sommet_plat);
        elseif left_hip_2(i)<0.3 && left_hip_2(i)>-0.5 %si le sommet est par contre situé entre 0.7 et -0.3 (à optimiser)
            if answerFinale(i-1)==2 && compteurl <= 100 % si avant on montait
                compteurl= compteurl +1;
                %answerl(i) = answerl(i-1); % on suppose qu'on ne descend pas directement après et qu'il y a au moins une sec entre les deux
            else
                answer_hanche_g=3; % sinon on descend
                compteurl = 0;
            end
            %else answerl(i)=answerl(i-1);%si le max n'est pas entre ces valeur on ne peut déterminer avec certitude -> comme avant
        end
        %else answerl(i) = answerl(i-1);
    end
    
    %% Genou Gauche
    k=1;
    if i>700
        if left_knee(i)>left_knee(i-k) && left_knee(i-k)<left_knee(i-2*k)% si on a un minima
            if left_knee(i) <110 % plus petit que 110
                kneeChangement=true;
            end
        end
    end
    
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
        ankleChangement=true;
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