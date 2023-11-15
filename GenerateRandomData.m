classdef GenerateRandomData
    methods (Static)
        function Data = Cities(N_Cities,Dimentions,Area,Shape)
            Data = containers.Map('KeyType','char','ValueType','any');
            ASCII_A = double('A');
            if Shape == "random"    
                Data('A') = zeros(1,Dimentions);
                for i = 1:1:N_Cities-1
                    Data( char(ASCII_A + i) ) = rand(1,Dimentions).*Area;
                end
            elseif Shape == "sphere"
                if Dimentions ~= 3
                    error("to make a sphere , Dimentions should be 3!");
                end
                n = sqrt(N_Cities-1);
                if n-floor(n)==0
                    n = floor(n);
                else
                    n = floor(n)+1;
                end
                [X,Y,Z] = sphere(n);
                X = ([X(1,1);reshape(X(2:n,:),[],(1));X(n+1,1)]+1)/2;
                Y = ([Y(1,1);reshape(Y(2:n,:),[],(1));Y(n+1,1)]+1)/2;
                Z = ([Z(1,1);reshape(Z(2:n,:),[],(1));Z(n+1,1)]+1)/2;
                for i = 1:N_Cities
                    Data( char(ASCII_A + i - 1) ) = [X(i) Y(i) Z(i)].*Area;
                end
            end
        end
        function Data = Chromosomes(N_Chromosomes,N_Cities)
            Data = cell(0);
            temp = 'A';
            for i = 1:N_Cities
               temp = string(temp) +  char('A' + i);
            end
            temp = char(temp);
            for i = 1:1:N_Chromosomes
                Data{i,1} = temp(randperm(N_Cities));
                Data{i,2} = GeneticFunctions.Fitness_Function(Data{i,1});
            end
            clear i j temp
        end
    end
end