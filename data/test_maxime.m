close all;
sol = [1 4 7];
for ii = 1:length(sol)
    %name = sprintf('s%dt%d_challenge',A(ii),2);
    name = sprintf('s%dt%d_solution',sol(ii),2);
    s = load(name);
    left_ankle = s.left_ankle;
    left_hip = s.left_hip;
    right_hip = s.right_hip;
    left_knee = s.left_knee;
    right_GRF = s.right_GRF; 
    time = s.time_vect;
    true_manoeuvre = s.true_manoeuvre;
    
    marche = NaN(1,length(true_manoeuvre));
    montee = NaN(1,length(true_manoeuvre));
    descente = NaN(1,length(true_manoeuvre));
    
    ind_marche    = find(true_manoeuvre == 1);
    ind_montee    =  find(true_manoeuvre ==  2);
    ind_descente =  find(true_manoeuvre == 3);
    
    vecteur = left_hip;
    
    marche(ind_marche)    = vecteur(ind_marche);
    montee(ind_montee)    = vecteur(ind_montee);
    descente(ind_descente) = vecteur(ind_descente);
    
    time_marche = time(ind_marche);
    time_montee = time(ind_montee);
    time_descente = time(ind_descente);
    
    
    data = left_hip;
    moyenne = [];
    
    for jj = 1:300:length(time)
        
        if jj+300 < length(time)
            moyenne = [moyenne mean(data(1,jj:jj+300))*ones(1,300)];
        else
            moyenne = [moyenne mean(data(1,jj:end))*ones(1,length(data(jj:end)))];
        end
    end
    
    figure;
    hold on
    plot(time, moyenne, 'k');
    plot(time, marche, 'r');
    plot(time, montee, 'g');
    plot(time, descente, 'b');
   title('right hip');
    xlabel('time (s)');
    ylabel('angle (°)');
    legend('marche','montee','descente');
    hold off
   
    
end