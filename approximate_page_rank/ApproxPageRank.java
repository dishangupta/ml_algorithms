import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.Map.Entry;


public class ApproxPageRank {
	
	public static void getNeighbors (String inputPath, Set<String> newNodes,
					Map<String, String[]> neighbors) {
		
		if (newNodes.isEmpty())
			return;
		
		try {
			BufferedReader reader = new BufferedReader(		
	            new FileReader(inputPath)); 
	            String line;
	            while ((line = reader.readLine()) != null) {
	            	//Find neighboring nodes for new nodes
	            	//with non-zero residuals
	            						
			String node = line.substring(0,line.indexOf("\t"));
	            	if (!newNodes.contains(node))
	            		continue;
	            	
	            	String[] nodeNeighbors = line.split("\\t");
			//node = nodeNeighbors[0];
	            		            		            	
	            	if (newNodes.contains(node)) 
	            		  neighbors.put(node, Arrays.copyOfRange(
	            				  nodeNeighbors, 1, nodeNeighbors.length));
	            	            	
	            }
	        }
		catch (Exception e) {
			e.printStackTrace();
			System.err.println("ERROR! File Not Found.");
		}
			
	}
	
	public static <K,V extends Comparable<? super V>> 
					List<Entry<K, V>> sortMapByValue(Map<K,V> map) {

		List<Entry<K,V>> sortedEntries = new ArrayList<Entry<K,V>>(map.entrySet());

		Collections.sort(sortedEntries, 
				new Comparator<Entry<K,V>>() {
			@Override
			public int compare(Entry<K,V> e1, Entry<K,V> e2) {
				return e2.getValue().compareTo(e1.getValue());
			}
		});

		return sortedEntries;
	}
		
	public static int computeBoundarySize (Set<String> S, String u,
						Map<String, String[]> neighbors) {
		
		int boundary = 0;
		String[] uNeighbors = neighbors.get(u);
		
		//Compute boundary size increment for the 
		//newest added node, u, to S
		for (String v : uNeighbors) {
			if (!S.contains(v))
				boundary++;
			else 
				boundary--;
		}
		
		return boundary;
	}
		
	public static void main (String[] args) {
		
		//Parse cmd-line arguments
		if (args.length < 4)
			System.err.println("ERROR! Not enough arguments");
	
		String inputPath = args[0];
		String seed = args[1];
		double alpha = Double.parseDouble(args[2]);
		double epsilon = Double.parseDouble(args[3]);
		
		//--------------APPROXIMATE PAGE RANK ON A VERY LARGE GRAPH--------------
		
		//Initialize p & r (sparse vectors)
		Map<String, Double> r = new HashMap<String, Double>();
		Map<String, Double> p = new HashMap<String, Double>();
		r.put(seed, 1D);
		
		//Store initial neighbors corresponding to seed
		Map<String, String[]> neighbors = new HashMap<String, String[]>();
		Set<String> nodesToStore = new HashSet<String>();
		nodesToStore.add(seed);
		getNeighbors(inputPath, nodesToStore, neighbors);
		nodesToStore.clear();
		
		int countOuter = 0;
		while (true) {
			
			int numPushesOuter = 0;
			//Iterate through the non-zero r nodes
			double ru, du, pu, rv;
			while (true) {
				int numPushesInner = 0;
				for (String u: neighbors.keySet()) {
					
					ru = r.get(u);
					du = neighbors.get(u).length;
					if (ru/du > epsilon) {
						numPushesOuter++;
						numPushesInner++;
						//-----Perform PUSH operation-----
											
						//Update p for current node u 
						pu = p.containsKey(u) ? p.get(u) : 0D; 
						p.put(u, pu + alpha*ru);
											
						//Update r for current node u
						r.put(u, ((1D-alpha)/2)*ru);
						
						//Update r for current node u's neighbors
						for (String v : neighbors.get(u)) {
							rv = r.containsKey(v) ? r.get(v) : 0D; 
							r.put(v, rv + ((1D-alpha)/2)*(ru/du));
						}
									
					}
				}
				
				//Check convergence of inner loop
				if (numPushesInner == 0)
					break;
			}
						 
			countOuter++;
			if (countOuter >= 6)
				break;
			
			//Check convergence of outer loop
			//if (numPushesOuter == 0)
			//	break;
			
			//Add neighbors corresponding to new non-zero residuals, r,  
			//with value greater than epsilon (for possible push)
			for (String u: r.keySet()) {
				if (r.get(u) > epsilon && !neighbors.containsKey(u))
					nodesToStore.add(u);
			}
			getNeighbors(inputPath, nodesToStore, neighbors);
			nodesToStore.clear();
		
		}
				
		//------------BUILD LOW-CONDUCTANCE SUBGRAPH------------
		
		//Initialize conductance sets
		Set<String> S = new HashSet<String>();
		Set<String> SStr = new HashSet<String>();
		S.add(seed);
		SStr.addAll(S);
						
		//Initialize conductances
		int volume = neighbors.get(seed).length;
		int boundarySize = computeBoundarySize(S, seed, neighbors);
		double conductanceS = (double) boundarySize/volume;		
		double conductanceSStr = conductanceS;
		
		//Sort p scores in descending order
		List<Entry<String, Double>> sortedP = sortMapByValue(p);
		
		//Build SStr greedily 
		for (int i = 0; i < sortedP.size(); i++) {
			String u = sortedP.get(i).getKey();
			
			//u=v0
			if (u.equals(seed))
				continue;
			
			S.add(u);
			volume = volume + neighbors.get(u).length;
			boundarySize = boundarySize + computeBoundarySize(S, u, neighbors);
			conductanceS = (double) boundarySize/volume;
		
			if (conductanceS < conductanceSStr) {
				SStr.addAll(S);
				conductanceSStr = conductanceS;
			}
		}
				
		for (String node : SStr)
			System.out.println(node + "\t" + p.get(node));
		
	}

}

