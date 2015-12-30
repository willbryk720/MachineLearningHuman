function [letters_dist_mat,count_each_letter]=user_finds_letters(in_mat)

%will take black/white image and show symbols one by one to user so user can teach computer symbols.
%Originally had faster version in which the user inputs all letters
%beforehand, but caused problems when symbol isolator function failed to
%isolate symbols absolutely perfectly. This version cannot be wrong unless
%usert teaches incorrectly (isolated blurry symbols are actually not always that easy to identify! That's 
% why the best machine learning algorithms use context).

figure
num_lett_line=300;
num_line=20;
map=[0 0 0;1 1 1];
colormap(map)

letters_dist_mat=zeros(200,200,93);
count_each_letter=zeros(1,93);


[r,c]=size(in_mat);
current_line_row=1;
current_line_col=1;


%After setting initial variables, begin search for letters and calculating
%prob distribution of each one and the count of each one


loc=0;
for j=1:num_line %looping through all lines of text

    %Find Line of letters
    for i=current_line_row:r
        sum_row=sum(in_mat(i,:));
        if sum_row>0
            row_value=i;
            break
        end
    end
    if (i==r && sum_row<1)  % In case there are no more lines left
        break
    end
    for i=row_value:r
        sum_row=sum(in_mat(i,:));
        if sum_row<1
           row_value_2=i-1;
           break
        elseif (i==r && sum_row>0) % In case line lasts until end row
           row_value_2=i;    
        end
    end
    current_line_row=row_value_2+1; %current_line_row has progressed to next line
    
    line_text=in_mat(row_value:row_value_2,:); %Found line of letters

    [r_box,c_box]=size(line_text);
    

    %Divide line of letters into box (size of line) with only one letter in it
    for z=1:num_lett_line  % looping through number of letters in line
        line_text_copy=zeros(r_box,c_box);
         for i=current_line_col:c
            sum_col=sum(line_text(:,i));
            if sum_col>0
                col_value=i;
                break
            end
         end
         if (i==c && sum_col<1)  % In case there are no more letters in line
              break
         end
         
         % We need to isolate letter from box. Originally I thought the
         % best method was to find the leftmost pixel and the rightmost
         % pixel and use all pixels in between. Problem is that I write my
         % letters atop one another so the rightmost pixel of the first
         % letter comes after the leftmost of the second. Solution: Start
         % from leftmost pixel, then find all pixels connected to it, by
         % checking all directions. Then ignore that whole symbol when
         % doing the same with the next letter. Two Lingering problems: 1. When
         % letters touch (as they do with messy handwriting like mine) 2.
         % with symbols that have two separate parts like 'i'
         % I have ideas. Will work on solution in further versions.

         %r_1,c_1 rows and columns of points with 1 at every stage
         [r_1,c_1]=find(line_text(:,col_value)==1);
         c_1=c_1+col_value-1;
         line_text_copy(r_1,col_value)=1;         
         %Now with the first few (or maybe 1), lets begin to find 1's of whole
         %letter
         for num_iterations=1:300
            num_new_points=0;
            numel_r_1=numel(r_1);  %just to make sure a changing r_1 size doesn't affect loop
            for i=1:numel_r_1 
                %m stands for move- ex. move up/left
                move=zeros(8,2);
                move(1,:)=[r_1(i)-1,c_1(i)];  %up          
                move(2,:)=[r_1(i)+1,c_1(i)];  %down
                move(3,:)=[r_1(i),c_1(i)-1];  %left
                move(4,:)=[r_1(i),c_1(i)+1];  %right
                move(5,:)=[r_1(i)-1,c_1(i)-1];  %up-left
                move(6,:)=[r_1(i)-1,c_1(i)+1];  %up-right
                move(7,:)=[r_1(i)+1,c_1(i)-1];  %down-left
                move(8,:)=[r_1(i)+1,c_1(i)+1];  %down-right
                for g=1:8
                    if ((move(g,1)>=1) && (move(g,1)<=r_box) && (move(g,2)>=1) && (move(g,2)<=c)) %make sure the coordinates of this point that surrounds the former exists
                        if ((line_text(move(g,1),move(g,2))==1) && (line_text_copy(move(g,1),move(g,2))==0))
                            num_new_points=num_new_points+1;
                            r_2(num_new_points)=move(g,1);
                            c_2(num_new_points)=move(g,2);
                            line_text_copy(move(g,1),move(g,2))=1;             
                        end
                    end
                end   
                
            end
            
            %In case there are no new points, and so the loop you end.
            %We've found that elusive letter!
            if (num_new_points>=1)
                r_1=r_2(1:num_new_points);
                c_1=c_2(1:num_new_points);        
            end
            if (num_new_points==0)
                break
            end
                
         end 
         
         
         %Now we have big linebox with letter inside. Lets isolate letter.
         %First by column

         for i=1:c
            sum_col=sum(line_text_copy(:,i));
            if sum_col>1
                col_value=i;
                break
            end  
         end
         for i=c_box:-1:1
            sum_col=sum(line_text_copy(:,i));
            if sum_col>0
                col_value_2=i;
                break
            end
         end
         current_line_col= col_value_2+1;
         
         %...Then by row
         for i=1:r_box
            sum_row=sum(line_text_copy(i,:));
            if sum_row>0
                row_box_value=i;
                break
            end
         end
         for i=r_box:-1:1
            sum_row=sum(line_text_copy(i,:));
            if sum_row>0
                row_box_value_2=i;
                break
            end
         end
         
        %Whala... but lets make sure the letter/symbol is not some random point or something. Its gotta be 9 or bigger
        %because thats already a period.
        if sum(sum(line_text_copy))<9
            continue
        end
        
        %Otherwise..
        next_letter= line_text_copy(row_box_value:row_box_value_2,col_value:col_value_2); %found letter
        loc=loc+1;        
        
        % now it's time for the user to teach the computer what each
        % capital letter looks like by telling it which image displays an 'A' or 'B'
        % or 'C' etc.
        colormap(map)
        image(next_letter==1)
        which_symbol=input('Enter which symbol this is. Enter "~" if symbol is unclear   ','s');
        v=double(which_symbol);
        v= v(v~=32)-32; %accidental spaces shouldn't matter
        if v>0 && v<94
            letters_dist_mat(:,:,v)=letters_dist_mat(:,:,v)+expand_logicmat(next_letter);
            count_each_letter(v)=count_each_letter(v)+1;
        end
        
    end
    disp('   ') %so I know its the next line

    current_line_col=1; %reset current_line_col to 1 bc we begin at one on next line of text

    
    if (row_value_2==r && j<num_line)
        break
    end
end  % end looping through all lines of text



end