%load('aes_power_data.mat')
%we imported the downloaded data rather than using the load function

plaintext_column=uint8(plain_text(:,16)); %16th byte of all of the plaintext messages in column vector 
key=uint8(0:255); %row vector of all possible key values
number_of_traces=200;
difference_of_means=NaN(256,40000);

pt_key_xor=bitxor(plaintext_column, key); % output of bitwise xor with plaintext and key 
% outputs a 200x256 matrix
% each row is the bitwise xor for the pt byte with every key guess
% 200 rows for the 200 pt messages

% adding 1 to all matrix elements to create the correct indices 
% [1:256] instead of [0:255]

new_pt_key_xor=pt_key_xor+1;

for a=1:256   % doing the same procedure for each password one at a time

s_box_output=sbox(new_pt_key_xor(:,a)); % the s-box output for all pt messages one key guess at a time

% take the LSB of all s box outputs

s_box_output_lsb=bitget(s_box_output,1);

% Selecting the number of traces to consider
traces=traces(1:number_of_traces,:);

bin_one_outputs=find(s_box_output_lsb); % finding the number of ones in the array

bin_zero_outputs=find(s_box_output_lsb==0); % finding the number of zeros in the array

bin_zero=traces(bin_zero_outputs,:);    % finding the bin_zero traces and including the 40000 instances
bin_one=traces(bin_one_outputs,:);  % finding the bin_one traces and including the 40000 instances

bin_zero_mean=mean(bin_zero);   % calculating the mean of both bin zero and bin one
bin_one_mean=mean(bin_one);

difference_of_means(a,:)=abs(bin_zero_mean-bin_one_mean);   % calculating the absolute value of the difference 

end

%plotting the last 16 key guess values, including the correct key guess value
x = 240:1:255;
for i=1:1:16 % plotting the passwords 16 at a time
subplot(4,4,i)
str_title = strcat('Key:  ', num2str(x(i)));
plot(difference_of_means((i+240),:))    % in order to plot higher passwords, I just add the appropriate constant to i (i.e. i+16 for plots 17:32)
title(str_title);
end
