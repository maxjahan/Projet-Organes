%% Hypothèses %%
% - On suppose que la personne démarre sur de plat et qu'elle y reste
% pendant au moins 150 observations, ce qui correspond à 1,5 sec. 


%% variables communes %%
l = length(time_vect);
answerTous = zeros(1, 4); % vecteur contenant toutes les possibilités pour un instant donné
answerFinale = zeros(1,l); % vecteur contenant la réponse pour chaque instant

%% variables LEFT HIP %%

maxInstant = zeros(1,l); % valeurs max de left hip entre l'instant donné et les 149 précédents
minInstant = zeros(1,l); % valeurs min de left hip entre l'instant donné et les 149 précédents
answerLeft = 0; % la réponse pour un instant donné en ne regardant que la hanche gauche


%% variables RIGHT HIP %%

maxInstantR = zeros(1,l); % même principe que pour la hanche gauche
minInstantR = zeros(1,l);
answerRight = 0;

%% variables KNEE %%
answer_knee = zeros(1,2); % réponse obtenue en regardant uniquement le genou gauche
maxInstantK = zeros(1,l); 
minInstantK = zeros(1,l);
densityLower = zeros(1,l);
densityUpper = zeros(1,l);

%% Code %%

for i = 1:l
    
  %% LEFT HIP %%
  
    if i<150  % si on est dans les 149 premières observations
        maxInstant(i) = max(left_hip(1:149)); % le max de ces observation
        minInstant(i) = min(left_hip(1:149)); % le min de ces observations
        answerLeft = 1; % on sait que endant cet instant là, on est sur du plat 
    else % si on est au delà de ces 150 premières observation, on ne concidère plus qu'on est sur du plat
        maxInstant(i) = max(left_hip(i-149:i)); % on recalcule donc le max
        minInstant(i) = min(left_hip(i-149:i)); % et le min. En fonction de leur valeurs, on avise:
        if minInstant(i) < minInstant(1) - minInstant(1)*0.1 % si le min est inférieur à celui du plat - un certain pourcentage
            answerLeft = 2; % on sait qu'on monte
        elseif  maxInstant(i) > maxInstant(1)- maxInstant(1)*0.035 % si le max est au dessus de celui du plat  un certain pourcentage
            answerLeft = 1; % on sait qu'on est sur du plat
            compteur3 = 0;
            compteur2 = 0;
        elseif maxInstant(i)-minInstant(i) < (maxInstant(1)-minInstant(1))*0.85 % si la variance est infériance à un certain pourcentage de la variance du plat
            compteur3 = 0;
            answerLeft = 3; % on sait qu'on descend        
        % si on entre dans aucune de ces condition, answerLeft garde la
        % même valeur qu'à l'itération précédente.
        end
    end
    
  %% RIGHT HIP %%
  
    if i<150 % l'algorythme est le même que pour la hanche gauche. Seules les pourcentages changes 
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
            compteur3R = 0;
            compteur2R = 0;
            answerRight = 1;
        end
    end
    
    %% Genou Gauche
   
    % Le genou va nous aider à différencier la montée ou la descente du
    % plat
  
      if i<150  % si on est dans les 149 premieres observations
          maxInstantK(i) = max(left_knee(1:149)); % le max de ces observation
          minInstantK(i) = min(left_knee(1:149)); % le min de ces observations
          answer_knee = [1 0]; % on sait que endant cet instant la, on est sur du plat
          densityLower(i) = sum(left_knee(find(left_knee(1:149)>minInstantK(1)-minInstantK(1)*0.16)))- sum(left_knee(find(left_knee(1:149)>minInstantK(1))));
          densityUpper(i) = sum(left_knee(find(left_knee(1:149)>maxInstantK(1)-maxInstantK(1)*0.2)))- sum(left_knee(find(left_knee(1:149)>maxInstantK(1)-maxInstantK(1)*0.12)));
      else % si on est au dela de ces 150 premieres observation, on ne concidere plus qu'on est sur du plat
          maxInstantK(i) = max(left_knee(i-149:i)); % on recalcule donc le max
          minInstantK(i) = min(left_knee(i-149:i)); % et le min. En fonction de leur valeurs, on avise:
          densityLower(i) = sum(left_knee(find(left_knee(i-149:i)>minInstantK(1)-minInstantK(1)*0.16)))- sum(left_knee(find(left_knee(i-149:i)>minInstantK(1))));
          densityUpper(i) = sum(left_knee(find(left_knee(i-149:i)>maxInstantK(1)-maxInstantK(1)*0.2)))- sum(left_knee(find(left_knee(i-149:i)>maxInstantK(1)-maxInstantK(1)*0.12)));
          if minInstantK(i) < minInstantK(1)-minInstantK(1)*0.12
               if densityLower(i) > densityUpper(i)
                  answer_knee = [2 0];
               elseif densityUpper(i) > densityLower(i)
                  answer_knee = [3 0];
               else answer_knee = [2 3];  
               end
          else answer_knee = [0 0];
          end
      end
  
  
  
  %% On assemble tout %%
    
    if answer_knee(1) ~= 0 % si le genou donne une info utile
        if answer_knee(2) == 0
            answerFinale(i) = mode([answerLeft answerRight answer_knee(1)]);
        else
            answerFinale(i) = mode([answerLeft answerRight answer_knee]); % on cherche le mode de nos réponses
        end
        elseif answerLeft == answerRight % sinon on observe que les haches. Si elles sont égales
            answerFinale(i) = answerLeft; % alors pas de souci, on est sur de la réponse.
        else answerFinale(i) = answerFinale(i-1); % sinon, dans le doute, on considère que la situation ne chang pas par rapport à l'itération précédente.
    end
    
end

%Pourcent = ((sum(answerFinale-true_manoeuvre==0))/length(true_manoeuvre))*100 % pourcentage de réponses correctes

figure
plot(time_vect, answerFinale, '.-b')
hold on 
%plot(time_vect, true_manoeuvre, '--r')
%legend('réponse obtenue','réponse donnée')

figure
plot(time_vect, left_hip, 'ob', 'markersize', 4)
hold on
plot(time_vect, maxInstant, '-g', 'markersize', 8 )
hold on
plot(time_vect, minInstant,'-r', 'markersize', 8)
legend('angle hanche gauche','enveloppe supérieure','enveloppe inférieure')
