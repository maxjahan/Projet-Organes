s = struct();
folder = 'C:\Users\Maxime\Documents\UNIF\Q6\Organes\data'; %// Place directory here

%// R�cup�re tout les fichiers
f = dir(fullfile(folder, '*.mat'));

%// Pour chaque fichier 
for idx = 1 : numel(f)

    %// R�cup�re le chemin vers le fichier
    name = fullfile(folder, f(idx).name);

    %// Charge ce fichier MAT ainsi que les variables voulus
    load(name, 'left_ankle');
    load(name, 'left_knee');
    load(name, 'left_hip');
    load(name, 'time_vect');
    load(name, 'right_hip');
    load(name, 'right_GRF');
    load(name, 'sub');

    %// R�cup�re le num�ro du sujet 
    numeroSujet = f(idx).name(2);
    
    s.(['left_ankle_' numeroSujet]) = left_ankle;
    s.(['left_knee_' numeroSujet]) = left_knee;
    s.(['left_hip_' numeroSujet]) = left_hip;
    s.(['time_vect_' numeroSujet]) = time_vect;
    s.(['right_hip_' numeroSujet]) = right_hip;
    s.(['right_GRF_' numeroSujet]) = right_GRF;
    s.(['sub_' numeroSujet]) = sub;
end