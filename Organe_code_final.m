%Hypothèses: -pendant les 7 premières secondes au moins, il est sur du plat
%            - Il y a au moins une seconde de marche entre une montée et
%            une descente 
%Algo: on calcul la valeur moyenne de l'angle de la hanche sur du plat
%pendant les 7 première secondes. On normalise pour que les cycles sur plat
%soient compris entr -1 et 1.
%Ensuite, en analysant les écart des pics par rapport à cette valeur moyenne, on détermine sur quel type de
%terrain on se trouve (plat, escaliers en montée, escaliers en descente).
close all

a=0;
b=0; %compteur minima
c=0; %compteur maxima
compteur = 0;
l = length(time_vect);
answer = zeros(1,l);
sommet_plat=0;
moyenne_sommet_plat=0;
minima_plat=0;
moyenne_minima_plat=0;

for i=1:l
    if i<700 %On suppose que le patient est sur du plat pendant au moins 7 sec
       a=a+right_hip(i); % pour pouvoir calculer la valeur moyenne
       answer(i)=1; % on est sur du plat
       if i>2 && right_hip(i)<right_hip(i-1) && right_hip(i-1)>right_hip(i-2)%si c'est un sommet
           b = b+1;
           sommet_plat(b)=right_hip(i);%matrice avec vleur des sommets
       elseif i>2 && right_hip(i)>right_hip(i-1) && right_hip(i-1)<right_hip(i-2)%si c'est un minima
           c = c+1;
           minima_plat(c)=right_hip(i);%matrice avec valeur des minima
       end
    elseif i==700
            a=(a+right_hip(i))/700;%valeur moyenne plat
            answer(i)=1;
            moyenne_sommet_plat = mean(sommet_plat);%valeur moyenne sommets sur plat
            moyenne_minima_plat = mean(minima_plat);%valeur moyenne minima sur plat
            right_hip_2 = (right_hip-a)/(moyenne_sommet_plat-moyenne_minima_plat);%on normalise la fonction (à faire au fur et à mesure dans la version finale!!!!!)
            plot(right_hip_2)
            %moyenne_sommet_plat = 1;
            %moyenne_minima_plat = -1;
    elseif right_hip_2(i)>right_hip_2(i-1) && right_hip_2(i-1)<right_hip_2(i-2)% son c'est un minima
        if right_hip_2(i)<-1.8 % et qu'il est plsu petit que -1.8
            answer(i)=2;% on est sur d'être en montée
        else answer(i) = answer(i-1);% sin le minima est ailleur on ne peut déterminer ou on se trouve donc on suppose que la situaion est la même qu'avant. 
        end
    elseif right_hip_2(i)<right_hip_2(i-1) && right_hip_2(i-1)>right_hip_2(i-4)%si on a un maxima
        if right_hip_2(i)>0.8%et qu'il est plus grand que 0.8
            answer(i)=1;%on est sur d'être sur du plat
            %sommet_plat(i)=right_hip(i);
            %moyenne_sommet_plat = mean(sommet_plat);
        elseif right_hip_2(i)<0.7 && right_hip_2(i)>-0.3 %si le sommet est par contre situé entre 0.7 et -0.3 (à optimiser)
            if answer(i-1)==2 && compteur <= 100 % si avant on montait
                compteur= compteur +1;
                answer(i) = answer(i-1); % on suppose qu'on ne descend pas directement après et qu'il y a au moins une sec entre les deux
            else
                answer(i)=3; % sinon on descend
                compteur = 0;
                valeur = right_hip_2(i)
                val_1 = right_hip_2(i-1)
                val_4 = right_hip_2(i-4)
            end    
        else answer(i)=answer(i-1);%si le max n'est pas entre ces valeur on ne peut déterminer avec certitude -> comme avant
        end
   else answer(i) = answer(i-1);% idem
   end
end
figure
plot(answer, '.-b')
%hold on
%plot(true_manoeuvre, '--r')
%figure
%plot(right_hip)
