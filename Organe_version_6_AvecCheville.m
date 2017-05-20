%% Hypotheses %%
% - On suppose que la personne demarre sur de plat et qu'elle y reste
% pendant au moins 150 observations, ce qui correspond a 1,5 sec. 


%% variables communes %%
l = length(time_vect);
%Suggestions; % vecteur contenant toutes les possibilites pour un instant donne
answerFinale = zeros(1,l); % vecteur contenant la reponse pour chaque instant

%% variables LEFT HIP %%

maxInstant = zeros(1,l); % valeurs max de left hip entre l'instant donne et les 149 precedents
minInstant = zeros(1,l); % valeurs min de left hip entre l'instant donne et les 149 precedents
answerLeft = 0; % la reponse pour un instant donne en ne regardant que la hanche gauche


%% variables RIGHT HIP %%

maxInstantR = zeros(1,l); % meme principe que pour la hanche gauche
minInstantR = zeros(1,l);
answerRight = 0;

%% variables KNEE %%
answer_knee = zeros(1,2); % reponse obtenue en regardant uniquement le genou gauche

%% variables ANKLE %%
ankleIs3=false; %variable qui certifie qu'on est dans une mont?e
ankleIsNot2=false; %variable qui certifie qu'on est pas dans une descente

a_ankle=0;
ankleIsNot2 = false;
ankleIs3 = false;

sommet_plat_ankle_max=0;
sommet_plat_ankle_min=2000;
compteur_ankle=0;

BMI=(sub.weight)/(sub.height)^2;

%% Code %%

for i = 1:l
    
  %% LEFT HIP %%
  
    if i<150  % si on est dans les 149 premieres observations
        maxInstant(i) = max(left_hip(1:149)); % le max de ces observations
        minInstant(i) = min(left_hip(1:149)); % le min de ces observations
        answerLeft = 1; % on sait que endeant cet instant la, on est sur du plat 
    else % si on est au dela de ces 150 premieres observations, on ne considere plus qu'on est sur du plat
        maxInstant(i) = max(left_hip(i-149:i)); % on recalcule donc le max
        minInstant(i) = min(left_hip(i-149:i)); % et le min. En fonction de leur valeurs, on avise:
        if minInstant(i) < minInstant(1) - minInstant(1)*0.1 % si le min est inferieur a celui du plat - un certain pourcentage
            answerLeft = 2; % on sait qu'on monte
        elseif  maxInstant(i) > maxInstant(1)- maxInstant(1)*0.035 % si le max est au dessus de celui du plat - un certain pourcentage
            answerLeft = 1; % on sait qu'on est sur du plat
        elseif maxInstant(i)-minInstant(i) < (maxInstant(1)-minInstant(1))*0.85 % si la variance est inferieure a un certain pourcentage de la variance du plat
            answerLeft = 3; % on sait qu'on descend        
        % si on entre dans aucune de ces conditions, answerLeft garde la
        % meme valeur qu'a l'iteration precedente.
        end
    end
    
  %% RIGHT HIP %%
  
    if i<150 % l'algorithme est le meme que pour la hanche gauche. Seules les pourcentages changent 
        maxInstantR(i) = max(right_hip(1:149));
        minInstantR(i) = min(right_hip(1:149));
        answerRight = 1;
    else
        maxInstantR(i) = max(right_hip(i-149:i));
        minInstantR(i) = min(right_hip(i-149:i));
        if minInstantR(i) < minInstantR(1) - minInstantR(1)*0.12
            answerRight = 2; 
        elseif maxInstantR(i)-minInstantR(i) < (maxInstantR(1)-minInstantR(1))*0.9
            answerRight = 3;            
        elseif  maxInstantR(i) > maxInstantR(1)- maxInstantR(1)*0.045
            answerRight = 1;
        end
    end
    
    %% Genou Gauche
   
    % Le genou va nous aider a differencier la montee ou la descente du
    % plat, chose que l'algorithme sur les hanches precedent a parfois du mal a faire
    if i>149 
      if left_knee(i)<110 % si la valeur de genou observee est inferieure a 110
            answer_knee = [2 3]; % on peut dire avec certitude qu'on monte OU qu'on descend
      else answer_knee = [0 0]; % sinon on ne peut pas donner d'info utile
      end
    end
    
    %% Cheville gauche
    if i<150 %On suppose que le patient est sur du plat pendant au moins 1,5 sec
        a_ankle=a_ankle+left_ankle(i); % pour pouvoir calculer la valeur moyenne
        ankleIsNot2=true; % on est sur du plat
        AnkleIsNot2(i)=1;
        if left_ankle(i)>sommet_plat_ankle_max
            sommet_plat_ankle_max = left_ankle(i);
        elseif left_ankle(i)<sommet_plat_ankle_min
            sommet_plat_ankle_min = left_ankle(i);
        end
    elseif i==150
        a_ankle=(a_ankle+left_ankle(i))/150;%valeur moyenne plat
        ankleIsNot2=true;
        AnkleIsNot2(i)=1;
        left_ankle_2 = (left_ankle-a_ankle)/(sommet_plat_ankle_max-sommet_plat_ankle_min);%on normalise la fonction
        
    elseif left_ankle_2(i)<left_ankle_2(i-1) && left_ankle_2(i-1)>left_ankle_2(i-2)%si on a un maximum
        if (sub.gender=='M' && BMI<21 && left_ankle_2(i)>0.84) || (sub.gender=='F' && left_ankle_2(i)>1.28) || (sub.gender=='M'&& BMI>21 && left_ankle_2(i)>0.75)
            ankleIsNot2=true; %on est sur d'etre sur du plat ou descente
        else
            compteur_ankle = 0; %sinon on n'a pas de nouvelles infos
        end
    elseif std(left_ankle_2(i-150:i))*BMI- std(left_ankle_2(1:150))*BMI > 4.4
        if answerFinale(i-1) == 2 && compteur_ankle <100 %ne peut pas redescendre dans la seconde quand il est sur du plat
            compteur_ankle = compteur_ankle+1;
        else
            ankleIs3 = true;
            compteur_ankle = 0;
        end
    end
    
  %% On assemble tout %%
  
  Suggestions=[answerLeft answerRight];
  if ankleIs3 % si on sait avec certitude qu'on descend
      Suggestions= [Suggestions 3];
  end
  if ankleIsNot2 % si on sait avec certitude qu'on ne monte pas
      Suggestions= [Suggestions 1 3];
  end
  if answer_knee(1) ~= 0 % si le genou donne une info utile
      Suggestions= [Suggestions answer_knee]; % on rajoute l'info du genou
      answerFinale(i)= mode(Suggestions);
  elseif answerLeft == answerRight % sinon on observe que les hanches. Si elles sont egales
      answerFinale(i) = answerLeft; % alors pas de souci, on est sur de la reponse.
  else answerFinale(i) = answerFinale(i-1); % sinon, dans le doute, on considere que la situation ne change pas par rapport a l'iteration precedente.
  end
    
end

Pourcent = ((sum(answerFinale-true_manoeuvre==0))/length(true_manoeuvre))*100 % pourcentage de reponses correctes

figure
plot(time_vect, answerFinale, '.-b')
hold on 
plot(time_vect, true_manoeuvre, '--r')
legend('reponse obtenue','reponse donnee')

figure
plot(time_vect, left_hip, 'ob', 'markersize', 4)
hold on
plot(time_vect, maxInstant, '-g', 'markersize', 8 )
hold on
plot(time_vect, minInstant,'-r', 'markersize', 8)
legend('angle hanche gauche','enveloppe superieure','enveloppe inferieure')
