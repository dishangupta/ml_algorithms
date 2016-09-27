import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.nio.charset.Charset;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.Vector;



public class LR {
	
	static double overflow = 20;
	
	protected static double sigmoid (double score) {
		if (score > overflow)
			score = overflow;
		else if (score < -overflow)
			score = -overflow;
		double exp = Math.exp(score);
		return exp/(1+exp);
	}
	
	public static Map<Integer, Integer> tokenizeDoc (String docText, int N) {
		
		String[] words = docText.split("\\s+");
		Map<Integer, Integer> features = new HashMap<Integer, Integer>();
				
		for (int i = 0; i < words.length; i++) {
			words[i] = words[i].replaceAll("\\W", "");
									
			if (words[i].length() > 0)  {
				int id = words[i].hashCode()%N;
				if (id < 0)
					id = id + N;
				
				if (features.containsKey(id))
					features.put(id, features.get(id) + 1);
				else
					features.put(id, 1);
			}
		
		}
		
		//Add bias
		features.put(N, 1);
				
		return features;
	}
	
	public static void main (String[] args) {
		
		//Construct global label set
		String[] globalLabels = {"nl", "el", "ru", "sl", "pl", "ca", 
								"fr", "tr", "hu", "de", "hr", "es", "ga", "pt"};
				
		//Parse command line arguments
		int N = Integer.parseInt(args[0]);
		double lambda = Double.parseDouble(args[1]);
		double mu = Double.parseDouble(args[2]);
		int T = Integer.parseInt(args[3]);
		int trainSize = Integer.parseInt(args[4]);
		String testFilePath = args[5];
		
		
		//------------------------TRAINING---------------------------
		
		double[][] B = new double[globalLabels.length][N+1];
		int[] A = new int[N+1];
						
		try {
			BufferedReader reader = new BufferedReader(		
					new InputStreamReader(System.in, Charset.defaultCharset())); 
		    String line;
		    String[] doc;
		    Set<String> labels;
		    Map<Integer, Integer> features;
		    
		    int t = 0;
		    int k = 0;
		    
		    while ((line = reader.readLine()) != null) {
		       	//Compute iteration number
		    	if (k%trainSize == 0) {
		    		t = t+1;
		    		if (t > T)
		    			break;
		    		
		    		lambda = lambda/(t*t);
		    	}	
		    			    	
		    	k = k+1;
		    	
		       	doc = line.split("\\t", 2);
		       	labels = new HashSet<String>(Arrays.asList(doc[0].split(",")));
		       	features = tokenizeDoc(doc[1], N);
		        
		       	int y;
		       	double p, betaDotX;
		       	for (int l = 0; l < globalLabels.length; l++) {
		       		//Get label for binary classification
		       		if (labels.contains(globalLabels[l]))
		       			y = 1;
		       		else
		       			y = 0;
		       	
		       		//Compute p
		       		betaDotX = 0.0;
		       		for (int j : features.keySet()) 
		       			betaDotX = betaDotX + B[l][j]*features.get(j); 
		       			       			
		       		p = sigmoid(betaDotX);
		       		
		       		//Gradient ascent update (with regularization)
		       		for (int j : features.keySet()) {
		       			B[l][j] = B[l][j]*Math.pow(1-2*lambda*mu, k-A[j]);  
		       			B[l][j] = B[l][j] + lambda*(y-p)*features.get(j);
		       			A[j] = k;
		       		}
		       		
		       	}
		    }
		    
		    for (int l = 0; l < globalLabels.length; l++) 
		    	for (int j = 0; j < N+1; j++)
		    		B[l][j] = B[l][j]*Math.pow(1-2*lambda*mu, k-A[j]); 
		    
		    reader.close();
		}
		
		catch (Exception e) {
				e.printStackTrace();
				System.out.println("No Input from StdIn!");
		}
		
		//------------------------TESTING---------------------------
		try {
			BufferedReader reader = new BufferedReader(		
					new FileReader(testFilePath)); 
			BufferedWriter writer = new BufferedWriter(
					new OutputStreamWriter(System.out));
			
			String line;
			String[] doc;
			Map<Integer, Integer> features;
			
			while ((line = reader.readLine()) != null) {
				doc = line.split("\\t", 2);
		       	features = tokenizeDoc(doc[1], N);
		       	
		       	String output = "";
		       	double p, betaDotX;
		    	for (int l = 0; l < globalLabels.length; l++) {
		    		//Compute p
		       		betaDotX = 0.0;
		       		for (int j : features.keySet()) 
		       			betaDotX = betaDotX + B[l][j]*features.get(j); 
		       			       			
		       		p = sigmoid(betaDotX);
		    	
		       		if (l == 0)
		       			output = output + globalLabels[l] + "\t" + p;
		       		else
		       			output = output + "," + globalLabels[l] + "\t" + p;
		    	}
		    	writer.write(output + "\n");
			}
			reader.close();
			writer.close();
		}
		
		catch (Exception e) {
			e.printStackTrace();
			System.out.println("Incorrect test file path");
		}
		
		
	}

}

