close all

a=0;
b=0; %compteur maxima
c=0; %compteur minima
compteur = 0;
l = length(time_vect);
answer = zeros(1,l);
sommet_plat=0;
moyenne_sommet_plat=0;
minima_plat=0;
moyenne_minima_plat=0;

for i=1:l
    if i<700 %On suppose que le patient est sur du plat pendant au moins 7 sec
       a=a+left_hip(i); % pour pouvoir calculer la valeur moyenne
       answer(i)=1; % on est sur du plat
       if i>2 && left_hip(i)<left_hip(i-1) && left_hip(i-1)>left_hip(i-2)%si c'est un sommet
           b = b+1;
           sommet_plat(b)=left_hip(i);%matrice avec valeurs des sommets
       elseif i>2 && left_hip(i)>left_hip(i-1) && left_hip(i-1)<left_hip(i-2)%si c'est un minima
           c = c+1;
           minima_plat(c)=left_hip(i);%matrice avec valeur des minima
       end
    elseif i==700
            a=(a+left_hip(i))/700;%valeur moyenne plat
            answer(i)=1;
            moyenne_sommet_plat = mean(sommet_plat);%valeur moyenne sommets sur plat
            moyenne_minima_plat = mean(minima_plat);%valeur moyenne minima sur plat
            left_hip_2 = (left_hip-a)/(moyenne_sommet_plat-moyenne_minima_plat);%on normalise la fonction (à faire au fur et à mesure dans la version finale!!!!!)
            plot(left_hip_2)
            %moyenne_sommet_plat = 1;
            %moyenne_minima_plat = -1;
    elseif left_hip_2(i)>left_hip_2(i-1) && left_hip_2(i-1)<left_hip_2(i-2)% sinon c'est un minima
        if left_hip_2(i)<-1 % et qu'il est plus petit que -1
            answer(i)=2;% on est sur d'être en montée
        else answer(i) = answer(i-1);% sin le minima est ailleur on ne peut déterminer ou on se trouve donc on suppose que la situaion est la même qu'avant. 
        end
    elseif left_hip_2(i)<left_hip_2(i-1) && left_hip_2(i-1)>left_hip_2(i-4)%si on a un maxima
        if left_hip_2(i)>0.4%et qu'il est plus grand que 0.8
            answer(i)=1;%on est sur d'être sur du plat
            %sommet_plat(i)=left_hip(i);
            %moyenne_sommet_plat = mean(sommet_plat);
        elseif left_hip_2(i)<0.5 && left_hip_2(i)>-0.7 %si le sommet est par contre situé entre 0.7 et -0.3 (à optimiser)
            if answer(i-1)==2 && compteur <= 100 % si avant on montait
                compteur= compteur +1;
                answer(i) = answer(i-1); % on suppose qu'on ne descend pas directement après et qu'il y a au moins une sec entre les deux
            else
                answer(i)=3; % sinon on descend
                compteur = 0;
            end    
        else answer(i)=answer(i-1);%si le max n'est pas entre ces valeur on ne peut déterminer avec certitude -> comme avant
        end
   else answer(i) = answer(i-1);% idem
    end
end
figure
plot(answer, '.-b')