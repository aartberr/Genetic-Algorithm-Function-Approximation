%Έλεγχος χρωμοσώματος
function fit=evaluateFitness(chromosome)
    numGaussians=size(chromosome.data,1);
    w=chromosome.data(:,1);
    c1=chromosome.data(:,2);
    c2=chromosome.data(:,3);
    sigma1=chromosome.data(:,4);
    sigma2=chromosome.data(:,5);

    %Αξιολόγηση χρωμοσώματος σύμφωνα με τα σημεία:
    num_points=50;
    u1=linspace(-1,2,num_points);
    u2=linspace(-2,1,num_points);

    %Συνδυασμός σημείων (κάθε σειρά είναι μια είσοδος)
    u=[u1',u2'];
    %Ανακάτεμα έτσι ώστε οι είσοδοι να είναι σχετικά τυχαίοι συνδυασμοί
    shuffled_indices=randperm(num_points);
    u1_shuffled=u(shuffled_indices,1);
    u=[u1_shuffled,u(:,2)];
    %Υπολογισμός εξόδου για κάθε είσοδο σύμφωνα με το μοντέλο υπολογισμού
    estimation=zeros(size(u,1),1);
    for j=1:size(u,1)
        for i=1:numGaussians
            estimation(j)=estimation(j)+w(i)*exp(-((u(j,1)-c1(i))^2/(2*sigma1(i)^2)+(u(j,2)-c2(i))^2/(2*sigma2(i)^2)));
        end
    end

    %Η δοσμένη έξοδος
    output=sin(u(:,1)+u(:,2)).*sin(u(:,2).^2);

    %1. Πόσο κοντά είναι η πραγματική έξοδος με αυτήν που υπολογίστηκε
    approachScore=1-mean(abs(output-estimation));
    %Επειδή οι έξοδοι είναι στο διάστημα [-1,1] αν η διαφορά της πραγματικής εξόδου με αυτήν 
    %που υπολογίστηκε είναι >1 τότε approachScore=0
    approachScore=max(approachScore,0);
    
    %2. Πόσους όρους έχουμε
    numZeroWeights=sum(w==0);
    zeroWeightScore=numZeroWeights/numGaussians;

    %Συνδυασμός των κριτηρίων για αξιολόγηση (βέλτιστο -> 1)
    weightCoefficient=0.3; %Ο αριθμός των Gaussian όρων συμβάλλει στο 30%
    fit=(1-weightCoefficient)*approachScore+weightCoefficient*zeroWeightScore;
end