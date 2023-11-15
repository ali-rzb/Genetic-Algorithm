classdef GeneticFunctions
    methods (Static)
        % GA Methods
        function output = Cross(Selected,Num)
            global N_Cities;
            output = [];
            len = length(Selected);
            n = 0;
            while true
                rand = randi(len);
                target = Selected(rand,:);
                temp = cell(0);
                ch = char(target{1});
                gen = randi(N_Cities-1);
                temp{1} = char( string( ch(1:gen) ) + string( flip( ch(gen+1:N_Cities) ) ) );
                temp{2} = GeneticFunctions.Fitness_Function(temp{1});
                output = [output;temp];
                n = n + 1;
                if n >= Num
                    break
                end
            end
        end
        function output = Mutation(Parents,Num)
            output = cell(0);
            global N_Cities
            for i = 1:Num
                index = randi(length(Parents));
                ch = char(Parents{index});
                
                target_A = randi(N_Cities);
                target_B = randi(N_Cities);
                
                temp = ch(target_A);
                ch(target_A) = ch(target_B);
                ch(target_B) = temp;

                output{i,1} = ch;
                output{i,2} = GeneticFunctions.Fitness_Function(ch);
            end
        end
        function [Selected,Not_Selected] = Selection(N_Childs,Parents)
            sorted_parents = sortrows(Parents,2);
            d_ranks=cell2mat(sorted_parents(:,2)).^-1;
            d_ranks = d_ranks / min(d_ranks);
            ranks = d_ranks.^20;
            ranks = ranks / min(ranks);
            [Childs_i,Repupulate_i] = GeneticFunctions.Roulette_wheel(ranks,N_Childs);
            Selected = sorted_parents(Childs_i,:);
            Not_Selected = sorted_parents(Repupulate_i,:);
            % GeneticFunctions.test_Roulette_plot(sorted_parents,Childs_i);
        end
        function [Selected,Not_Selected]  = Roulette_wheel(ranks,Num)
            ranks_sum = sum(ranks);
            ranks = [ranks,(1:1:length(ranks))'];
            output = zeros(Num,1);
            for i = 1:1:Num
                target = ranks_sum*rand(1);
                current = 0;
                for j = 1:1:length(ranks)
                    current = current + ranks(j,1);
                    if current >= target
                        output(i) = ranks(j,2);
                        ranks_sum = ranks_sum - ranks(j,1);
                        ranks(j,:) = [];
                        break 
                    end
                end
            end
            Selected = output;
            Not_Selected = zeros(length(ranks),1);
            for i = 1:1:length(ranks)
               Not_Selected(i) = ranks(i,2); 
            end
        end
        function output = Fitness_Function(Chromosome)
            global Cities N_Cities
            output = 0;
            chromosome = char(Chromosome);
            for i = 1:1:N_Cities-1
                orig = Cities(chromosome(i));   %Origin
                dest = Cities(chromosome(i+1)); %Destination
                output = output + norm(orig-dest);
            end 
            orig = Cities(chromosome(i+1));
            dest = Cities(chromosome(1));
            output = output + norm(orig-dest);
        end
        %% plot functions
        function plot_way(ch,Title,Dimentions,all_ranks,end_text)
            global Cities N_Cities
            ch_i = ch - double('A')+1;
            points = reshape(cell2mat(values(Cities)),Dimentions,[]);
            ordered_points = [];
            for i = 1:1:N_Cities
                ordered_points = [ordered_points,points(:,ch_i(i))];
            end
            ordered_points = [ordered_points,points(:,ch_i(1))];
            subplot(3,4,5); 
            plot(1:length(all_ranks),all_ranks);
            len = length(all_ranks);
            pad = 0.1*len;
            xlim([-pad length(all_ranks)+pad]);
            y_max = max(all_ranks);
            y_min = min(all_ranks);
            pad = (y_max - y_min)*0.1;
            ylim([y_min-pad y_max+pad])
            ylabel('min distance')
            xlabel('Generation')
            title('Generation : '+string(len))
            axis tight
            
            
            
            subplot(3,4,9);
            t = text(0,0.4,end_text);
            t.FontWeight = 'normal';
            t.FontSize = 10;
            t.FontName = 'Roboto';
            t.Color = 'Red';
            axis off
            
            subplot(3,4,[2,3,4, 6,7,8, 10,11,12]);
            if Dimentions==2
                plot(ordered_points(1,:),ordered_points(2,:));
            elseif Dimentions==3
                plot3(ordered_points(1,:),ordered_points(2,:),ordered_points(3,:)...
                    ,'-o','Color','b','MarkerSize',10,'MarkerFaceColor','#D9FFFF');
            else
                error('Unown Dimentions!');
            end
            title(Title)
            grid on
            axis tight
            
            
            fig=gcf;
            scr_siz = get(0,'ScreenSize') ;
            h=scr_siz(4)/1.5;
            w=h*1.5;
            x=(scr_siz(3)-w)/2;
            y=(scr_siz(4)-h)/2;
            fig.Position(1:4)=floor([x y w h]);
            
            figure(gcf)
        end
        function plot_info(infotext)
            subplot(3,4,1);
            text(0,0.4,infotext);
            axis off
        end
        function test_Roulette_plot(Parents,selected_i)
            
            subplot(1,1,1)
            parents_sorted = [sortrows( [cell2mat(Parents(:,2)),(1:1:length(Parents))'] ,1),(1:1:length(Parents))'];
            selected = [];
            for i = 1:1:length(selected_i)
                index = parents_sorted(:,2) == selected_i(i);
                selected = [selected;parents_sorted(index,:)];
            end
            selected = sortrows(selected,1);
            density = [];
            width = 40;
            for i = 0:width:int64(length(Parents)/width)*width
                n = length(find( selected(:,3)>=i &  selected(:,3)<=i+width));
                density = [density; n ,i];
            end
            plot( (1:1:length(Parents)) ,parents_sorted(:,1),'.k', selected(:,3) ,selected(:,1),'.r',density(:,2),density(:,1),density(:,2),density(:,1),'o');
            xline(density(:,2))
            xlim( [1 length(Parents)] )
            title('ranks^20')
            legend('All of Parents','Selected Parents','Moving Average')
            figure()
            
        end
        %% end condition check
        function result = end_condition(check_range,all_ranks)
            len = length(all_ranks);
            if len > check_range
                if min(all_ranks(1:len-check_range)) == min(all_ranks(len-check_range+1:len))
                    result = true;
                else
                    result = false;
                end
            else
                result = false;
            end
        end
    end
end