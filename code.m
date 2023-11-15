%% Restart
clear;clear;close all;clc;
global N_Cities N_Chromosomes

%% input Configurations
N_Cities = 25;
Cities_Shape = 'sphere';
N_Chromosomes = 500;
Percent_Selection = 50;
Percent_Cross = 45;
Percent_Mutate = 5;
iterations = 5000;
Dimentions = 3;
Area = [3 4 5];
end_check_width = 100;

%% Initialize Variables
text = sprintf(' %s : %s\n',[...
    ["Cities","Chromosomes","% Repupulate","% Cross","% Mutate"];...
    [N_Cities,N_Chromosomes,Percent_Selection,Percent_Cross,Percent_Mutate] ]);
GeneticFunctions.plot_info(text);
N_Selection = floor(N_Chromosomes*Percent_Selection/100);
N_Cross = floor(N_Chromosomes*Percent_Cross/100);
N_Mutate = floor(N_Chromosomes*Percent_Mutate/100);
global Cities Chromosomes
Cities = GenerateRandomData.Cities(N_Cities,Dimentions,Area,Cities_Shape);
Chromosomes = GenerateRandomData.Chromosomes(N_Chromosomes,N_Cities);
best_rank = min(cell2mat(Chromosomes(:,2)));
best_way = Chromosomes{cell2mat(Chromosomes(:,2)) == best_rank , 1};
all_ranks = [];
all_ranks(end+1) = best_rank;
n = 0;
tic

%% Start Evolutionation
while true
    clc; n = n + 1; fprintf('%4d', n);
    if n == iterations
       break;
    end
    
    [Selected,Not_Selected] = GeneticFunctions.Selection(N_Selection,Chromosomes);
    Cross=GeneticFunctions.Cross(Selected,N_Cross);
    Mutate = GeneticFunctions.Mutation(Cross,N_Mutate);
    Chromosomes = [Selected;Cross;Mutate];

    
    % check for best way
    ranks_mat = cell2mat(Chromosomes(:,2));
    best = min(ranks_mat);
    all_ranks(end+1) = best;
    if best < best_rank
       best_rank = best;
       index = find(ranks_mat == best_rank);
       best_way = Chromosomes{index , 1};
       title = "Best Guess → " + string(n) + "th Generation , Distance : "...
           +string(best_rank);
       GeneticFunctions.plot_way(best_way,title,Dimentions,all_ranks,'');
    elseif rem(n,1)==0
        check = exist('title','var');
        if check
            GeneticFunctions.plot_way(best_way,title,Dimentions,all_ranks,'');
        end
    end
    
    
    % Check for Termination
    if GeneticFunctions.end_condition(end_check_width,all_ranks)
        end_text = {"no improvements in "+string(end_check_width)+...
            " cycles.","Evolutionation Time : "+sprintf('%.2f',toc)};
        GeneticFunctions.plot_way(best_way,title,Dimentions,all_ranks,end_text);
        break
    end
end