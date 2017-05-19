%% Hypoth�ses %%
% - On suppose que la personne d�marre sur de plat et qu'elle y reste
% pendant au moins 150 observations, ce qui correspond � 1,5 sec. 


%% variables communes %%
l = length(time_vect);
answerTous = zeros(1, 4); % vecteur contenant toutes les possibilit�s pour un instant donn�
answerFinale = zeros(1,l); % vecteur contenant la r�ponse pour chaque instant

%% variables LEFT HIP %%

maxInstant = zeros(1,l); % valeurs max de left hip entre l'instant donn� et les 149 pr�c�dents
minInstant = zeros(1,l); % valeurs min de left hip entre l'instant donn� et les 149 pr�c�dents
answerLeft = 0; % la r�ponse pour un instant donn� en ne regardant que la hanche gauche
compteur2 = 0;
compteur3 = 0;

nombreSec = 160; %nombre de seconde pendant lesquel il est impossible qu'une personne descende ou monte apr�s avoir mont�/descendu


%% variables RIGHT HIP %%

maxInstantR = zeros(1,l); % m�me principe que pour la hanche gauche
minInstantR = zeros(1,l);
answerRight = 0;
compteur2R = 0;
compteur3R = 0;

%% variables KNEE %%
answer_knee = zeros(1,2); % r�ponse obtenue en regardant uniquement le genou gauche


%% Code %%

for i = 1:l
    
  %% LEFT HIP %%
  
    if i<150  % si on est dans les 149 premi�res observations
        maxInstant(i) = max(left_hip(1:149)); % le max de ces observation
        minInstant(i) = min(left_hip(1:149)); % le min de ces observations
        answerLeft = 1; % on sait que endant cet instant l�, on est sur du plat 
    else % si on est au del� de ces 150 premi�res observation, on ne concid�re plus qu'on est sur du plat
        maxInstant(i) = max(left_hip(i-149:i)); % on recalcule donc le max
        minInstant(i) = min(left_hip(i-149:i)); % et le min. En fonction de leur valeurs, on avise:
        if minInstant(i) < minInstant(1) - minInstant(1)*0.1 % si le min est inf�rieur � celui du plat - un certain pourcentage
            compteur2 = 0;
            if answerLeft == 3 && compteur3 < nombreSec
                compteur3 = compteur3+1;
            else
                answerLeft = 2; % on sait qu'on monte
                compteur3 = 0;
            end
        elseif  maxInstant(i) > maxInstant(1)- maxInstant(1)*0.035 % si le max est au dessus de celui du plat  un certain pourcentage
            answerLeft = 1; % on sait qu'on est sur du plat
            compteur3 = 0;
            compteur2 = 0;
        elseif maxInstant(i)-minInstant(i) < (maxInstant(1)-minInstant(1))*0.85 % si la variance est inf�riance � un certain pourcentage de la variance du plat
            compteur3 = 0;
            if answerLeft == 2 && compteur2 < nombreSec
                compteur2 = compteur2+1;
            else
                answerLeft = 3; % on sait qu'on descend
                compteur2 = 0;
            end            
        % si on entre dans aucune de ces condition, answerLeft garde la
        % m�me valeur qu'� l'it�ration pr�c�dente.
        end
    end
    
  %% RIGHT HIP %%
  
    if i<150 % l'algorythme est le m�me que pour la hanche gauche. Seules les pourcentages changes 
        maxInstantR(i) = max(right_hip(1:149));
        minInstantR(i) = min(right_hip(1:149));
        answerRight = 1;
    else
        maxInstantR(i) = max(right_hip(i-149:i));
        minInstantR(i) = min(right_hip(i-149:i));
        if minInstantR(i) < minInstantR(1) - minInstantR(1)*0.12
            compteur2R = 0;
           if answerRight == 3 && compteur3R < nombreSec
                compteur3R = compteur3R+1;
           else
                answerRight = 2; 
                compteur3R = 0;
           end
        elseif maxInstantR(i)-minInstantR(i) < (maxInstantR(1)-minInstantR(1))*0.9
            compteur3R = 0;
            if answerRight == 2 && compteur2R < nombreSec
                compteur2R = compteur2R+1;
            else
                answerRight = 3; 
                compteur2R = 0;
            end            
        elseif  maxInstantR(i) > maxInstantR(1)- maxInstantR(1)*0.045
            compteur3R = 0;
            compteur2R = 0;
            answerRight = 1;
        end
    end
    
    %% Genou Gauche
   
    % Le genou va nous aider � diff�rencier la mont�e ou la descente du
    % plat, chose que l'algorythme sur les hanches pr�c�dent a parfois du mal � faire
    if i>149 
      if left_knee(i)<110 % si la valeur de genou observ�e est inf�rieures � 110
            answer_knee = [2 3]; % on peut dire avec certitude qu'on monte OU qu'on descend
      else answer_knee = [0 0]; % sinon on ne peut pas donner d'info utile
      end
    end
  
  
  %% On assemble tout %%
    
    if answer_knee(1) ~= 0 % si le genou donne une info utile
            answerFinale(i) = mode([answerLeft answerRight answer_knee]); % on cherche le mode de nos r�ponses
        elseif answerLeft == answerRight % sinon on observe que les haches. Si elles sont �gales
            answerFinale(i) = answerLeft; % alors pas de souci, on est sur de la r�ponse.
        else answerFinale(i) = answerFinale(i-1); % sinon, dans le doute, on consid�re que la situation ne chang pas par rapport � l'it�ration pr�c�dente.
    end
    
end

Pourcent = ((sum(answerFinale-true_manoeuvre==0))/length(true_manoeuvre))*100 % pourcentage de r�ponses correctes

figure
plot(time_vect, answerFinale, '.-b')
hold on 
plot(time_vect, true_manoeuvre, '--r')
legend('r�ponse obtenue','r�ponse donn�e')

figure
plot(time_vect, left_hip, 'ob', 'markersize', 4)
hold on
plot(time_vect, maxInstant, '-g', 'markersize', 8 )
hold on
plot(time_vect, minInstant,'-r', 'markersize', 8)
legend('angle hanche gauche','enveloppe sup�rieure','enveloppe inf�rieure')

compteur3
compteur2
compteur3R
compteur2R