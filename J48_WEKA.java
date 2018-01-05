// Generated with Weka 3.8.0
//
// This code is public domain and comes with no warranty.
//
// Timestamp: Sun Oct 02 08:46:33 CEST 2016

package weka.classifiers;

import weka.core.Attribute;
import weka.core.Capabilities;
import weka.core.Capabilities.Capability;
import weka.core.Instance;
import weka.core.Instances;
import weka.core.RevisionUtils;
import weka.classifiers.Classifier;
import weka.classifiers.AbstractClassifier;

public class WekaWrapper
  extends AbstractClassifier {

  /**
   * Returns only the toString() method.
   *
   * @return a string describing the classifier
   */
  public String globalInfo() {
    return toString();
  }

  /**
   * Returns the capabilities of this classifier.
   *
   * @return the capabilities
   */
  public Capabilities getCapabilities() {
    weka.core.Capabilities result = new weka.core.Capabilities(this);

    result.enable(weka.core.Capabilities.Capability.NOMINAL_ATTRIBUTES);
    result.enable(weka.core.Capabilities.Capability.NUMERIC_ATTRIBUTES);
    result.enable(weka.core.Capabilities.Capability.DATE_ATTRIBUTES);
    result.enable(weka.core.Capabilities.Capability.MISSING_VALUES);
    result.enable(weka.core.Capabilities.Capability.NOMINAL_CLASS);
    result.enable(weka.core.Capabilities.Capability.MISSING_CLASS_VALUES);


    result.setMinimumNumberInstances(0);

    return result;
  }

  /**
   * only checks the data against its capabilities.
   *
   * @param i the training data
   */
  public void buildClassifier(Instances i) throws Exception {
    // can classifier handle the data?
    getCapabilities().testWithFail(i);
  }

  /**
   * Classifies the given instance.
   *
   * @param i the instance to classify
   * @return the classification result
   */
  public double classifyInstance(Instance i) throws Exception {
    Object[] s = new Object[i.numAttributes()];
    
    for (int j = 0; j < s.length; j++) {
      if (!i.isMissing(j)) {
        if (i.attribute(j).isNominal())
          s[j] = new String(i.stringValue(j));
        else if (i.attribute(j).isNumeric())
          s[j] = new Double(i.value(j));
      }
    }
    
    // set class value to missing
    s[i.classIndex()] = null;
    
    return J48WekaClassifier.classify(s);
  }

  /**
   * Returns the revision string.
   * 
   * @return        the revision
   */
  public String getRevision() {
    return RevisionUtils.extract("1.0");
  }

  /**
   * Returns only the classnames and what classifier it is based on.
   *
   * @return a short description
   */
  public String toString() {
    return "Auto-generated classifier wrapper, based on weka.classifiers.trees.J48 (generated with Weka 3.8.0).\n" + this.getClass().getName() + "/J48WekaClassifier";
  }

  /**
   * Runs the classfier from commandline.
   *
   * @param args the commandline arguments
   */
  public static void main(String args[]) {
    runClassifier(new WekaWrapper(), args);
  }
}

class J48WekaClassifier {

  public static double classify(Object[] i)
    throws Exception {

    double p = Double.NaN;
    p = J48WekaClassifier.N715f70c0(i);
    return p;
  }
  static double N715f70c0(Object []i) {
    double p = Double.NaN;
    if (i[4] == null) {
      p = 4;
    } else if (((Double) i[4]).doubleValue() <= 0.101402) {
    p = J48WekaClassifier.N191f22b41(i);
    } else if (((Double) i[4]).doubleValue() > 0.101402) {
    p = J48WekaClassifier.Nbb13d4170(i);
    } 
    return p;
  }
  static double N191f22b41(Object []i) {
    double p = Double.NaN;
    if (i[52] == null) {
      p = 4;
    } else if (((Double) i[52]).doubleValue() <= 0.007037) {
    p = J48WekaClassifier.N37616eca2(i);
    } else if (((Double) i[52]).doubleValue() > 0.007037) {
    p = J48WekaClassifier.N6f29295926(i);
    } 
    return p;
  }
  static double N37616eca2(Object []i) {
    double p = Double.NaN;
    if (i[62] == null) {
      p = 4;
    } else if (((Double) i[62]).doubleValue() <= 0.00659) {
    p = J48WekaClassifier.N614f1143(i);
    } else if (((Double) i[62]).doubleValue() > 0.00659) {
    p = J48WekaClassifier.N34f106eb14(i);
    } 
    return p;
  }
  static double N614f1143(Object []i) {
    double p = Double.NaN;
    if (i[63] == null) {
      p = 24;
    } else if (((Double) i[63]).doubleValue() <= 0.006735) {
    p = J48WekaClassifier.N2e11cb4d4(i);
    } else if (((Double) i[63]).doubleValue() > 0.006735) {
    p = J48WekaClassifier.N7386570e8(i);
    } 
    return p;
  }
  static double N2e11cb4d4(Object []i) {
    double p = Double.NaN;
    if (i[64] == null) {
      p = 24;
    } else if (((Double) i[64]).doubleValue() <= 0.006657) {
    p = J48WekaClassifier.N4e7b56b95(i);
    } else if (((Double) i[64]).doubleValue() > 0.006657) {
    p = J48WekaClassifier.N53eda59d7(i);
    } 
    return p;
  }
  static double N4e7b56b95(Object []i) {
    double p = Double.NaN;
    if (i[106] == null) {
      p = 24;
    } else if (((Double) i[106]).doubleValue() <= 0.008828) {
      p = 24;
    } else if (((Double) i[106]).doubleValue() > 0.008828) {
    p = J48WekaClassifier.N72d066826(i);
    } 
    return p;
  }
  static double N72d066826(Object []i) {
    double p = Double.NaN;
    if (i[67] == null) {
      p = 13;
    } else if (((Double) i[67]).doubleValue() <= 0.005488) {
      p = 13;
    } else if (((Double) i[67]).doubleValue() > 0.005488) {
      p = 23;
    } 
    return p;
  }
  static double N53eda59d7(Object []i) {
    double p = Double.NaN;
    if (i[49] == null) {
      p = 0;
    } else if (((Double) i[49]).doubleValue() <= 0.007254) {
      p = 0;
    } else if (((Double) i[49]).doubleValue() > 0.007254) {
      p = 22;
    } 
    return p;
  }
  static double N7386570e8(Object []i) {
    double p = Double.NaN;
    if (i[66] == null) {
      p = 4;
    } else if (((Double) i[66]).doubleValue() <= 0.009477) {
    p = J48WekaClassifier.N675c19599(i);
    } else if (((Double) i[66]).doubleValue() > 0.009477) {
      p = 23;
    } 
    return p;
  }
  static double N675c19599(Object []i) {
    double p = Double.NaN;
    if (i[65] == null) {
      p = 4;
    } else if (((Double) i[65]).doubleValue() <= 0.008034) {
    p = J48WekaClassifier.N1649974610(i);
    } else if (((Double) i[65]).doubleValue() > 0.008034) {
      p = 3;
    } 
    return p;
  }
  static double N1649974610(Object []i) {
    double p = Double.NaN;
    if (i[86] == null) {
      p = 4;
    } else if (((Double) i[86]).doubleValue() <= 0.006598) {
    p = J48WekaClassifier.N2836195f11(i);
    } else if (((Double) i[86]).doubleValue() > 0.006598) {
    p = J48WekaClassifier.N69c9157012(i);
    } 
    return p;
  }
  static double N2836195f11(Object []i) {
    double p = Double.NaN;
    if (i[50] == null) {
      p = 10;
    } else if (((Double) i[50]).doubleValue() <= 0.006449) {
      p = 10;
    } else if (((Double) i[50]).doubleValue() > 0.006449) {
      p = 4;
    } 
    return p;
  }
  static double N69c9157012(Object []i) {
    double p = Double.NaN;
    if (i[85] == null) {
      p = 21;
    } else if (((Double) i[85]).doubleValue() <= 0.009678) {
    p = J48WekaClassifier.N6e585fc113(i);
    } else if (((Double) i[85]).doubleValue() > 0.009678) {
      p = 10;
    } 
    return p;
  }
  static double N6e585fc113(Object []i) {
    double p = Double.NaN;
    if (i[8] == null) {
      p = 12;
    } else if (((Double) i[8]).doubleValue() <= 0.105488) {
      p = 12;
    } else if (((Double) i[8]).doubleValue() > 0.105488) {
      p = 21;
    } 
    return p;
  }
  static double N34f106eb14(Object []i) {
    double p = Double.NaN;
    if (i[54] == null) {
      p = 13;
    } else if (((Double) i[54]).doubleValue() <= 0.007252) {
    p = J48WekaClassifier.N2c151dcb15(i);
    } else if (((Double) i[54]).doubleValue() > 0.007252) {
    p = J48WekaClassifier.N19592e2419(i);
    } 
    return p;
  }
  static double N2c151dcb15(Object []i) {
    double p = Double.NaN;
    if (i[43] == null) {
      p = 13;
    } else if (((Double) i[43]).doubleValue() <= 0.005554) {
      p = 13;
    } else if (((Double) i[43]).doubleValue() > 0.005554) {
    p = J48WekaClassifier.Nd56efac16(i);
    } 
    return p;
  }
  static double Nd56efac16(Object []i) {
    double p = Double.NaN;
    if (i[53] == null) {
      p = 18;
    } else if (((Double) i[53]).doubleValue() <= 0.007825) {
      p = 18;
    } else if (((Double) i[53]).doubleValue() > 0.007825) {
    p = J48WekaClassifier.N215c1f9017(i);
    } 
    return p;
  }
  static double N215c1f9017(Object []i) {
    double p = Double.NaN;
    if (i[50] == null) {
      p = 0;
    } else if (((Double) i[50]).doubleValue() <= 0.007933) {
      p = 0;
    } else if (((Double) i[50]).doubleValue() > 0.007933) {
    p = J48WekaClassifier.N1d26930e18(i);
    } 
    return p;
  }
  static double N1d26930e18(Object []i) {
    double p = Double.NaN;
    if (i[39] == null) {
      p = 17;
    } else if (((Double) i[39]).doubleValue() <= 0.007008) {
      p = 17;
    } else if (((Double) i[39]).doubleValue() > 0.007008) {
      p = 4;
    } 
    return p;
  }
  static double N19592e2419(Object []i) {
    double p = Double.NaN;
    if (i[44] == null) {
      p = 10;
    } else if (((Double) i[44]).doubleValue() <= 0.006649) {
      p = 10;
    } else if (((Double) i[44]).doubleValue() > 0.006649) {
    p = J48WekaClassifier.N23c8992c20(i);
    } 
    return p;
  }
  static double N23c8992c20(Object []i) {
    double p = Double.NaN;
    if (i[61] == null) {
      p = 3;
    } else if (((Double) i[61]).doubleValue() <= 0.007705) {
    p = J48WekaClassifier.N6229a25a21(i);
    } else if (((Double) i[61]).doubleValue() > 0.007705) {
    p = J48WekaClassifier.N7ca0270224(i);
    } 
    return p;
  }
  static double N6229a25a21(Object []i) {
    double p = Double.NaN;
    if (i[66] == null) {
      p = 3;
    } else if (((Double) i[66]).doubleValue() <= 0.008064) {
    p = J48WekaClassifier.N4bbef3f222(i);
    } else if (((Double) i[66]).doubleValue() > 0.008064) {
    p = J48WekaClassifier.N1bc6dcaf23(i);
    } 
    return p;
  }
  static double N4bbef3f222(Object []i) {
    double p = Double.NaN;
    if (i[76] == null) {
      p = 6;
    } else if (((Double) i[76]).doubleValue() <= 0.005422) {
      p = 6;
    } else if (((Double) i[76]).doubleValue() > 0.005422) {
      p = 3;
    } 
    return p;
  }
  static double N1bc6dcaf23(Object []i) {
    double p = Double.NaN;
    if (i[88] == null) {
      p = 0;
    } else if (((Double) i[88]).doubleValue() <= 0.00719) {
      p = 0;
    } else if (((Double) i[88]).doubleValue() > 0.00719) {
      p = 9;
    } 
    return p;
  }
  static double N7ca0270224(Object []i) {
    double p = Double.NaN;
    if (i[51] == null) {
      p = 12;
    } else if (((Double) i[51]).doubleValue() <= 0.007593) {
      p = 12;
    } else if (((Double) i[51]).doubleValue() > 0.007593) {
    p = J48WekaClassifier.N53b461be25(i);
    } 
    return p;
  }
  static double N53b461be25(Object []i) {
    double p = Double.NaN;
    if (i[106] == null) {
      p = 24;
    } else if (((Double) i[106]).doubleValue() <= 0.007236) {
      p = 24;
    } else if (((Double) i[106]).doubleValue() > 0.007236) {
      p = 23;
    } 
    return p;
  }
  static double N6f29295926(Object []i) {
    double p = Double.NaN;
    if (i[43] == null) {
      p = 6;
    } else if (((Double) i[43]).doubleValue() <= 0.008027) {
    p = J48WekaClassifier.N4227b3b727(i);
    } else if (((Double) i[43]).doubleValue() > 0.008027) {
    p = J48WekaClassifier.N8a249261(i);
    } 
    return p;
  }
  static double N4227b3b727(Object []i) {
    double p = Double.NaN;
    if (i[23] == null) {
      p = 11;
    } else if (((Double) i[23]).doubleValue() <= 0.00841) {
    p = J48WekaClassifier.N3fc204c628(i);
    } else if (((Double) i[23]).doubleValue() > 0.00841) {
    p = J48WekaClassifier.N57f1ed2149(i);
    } 
    return p;
  }
  static double N3fc204c628(Object []i) {
    double p = Double.NaN;
    if (i[63] == null) {
      p = 16;
    } else if (((Double) i[63]).doubleValue() <= 0.008544) {
    p = J48WekaClassifier.N4f8b3b1129(i);
    } else if (((Double) i[63]).doubleValue() > 0.008544) {
    p = J48WekaClassifier.N402bd9d945(i);
    } 
    return p;
  }
  static double N4f8b3b1129(Object []i) {
    double p = Double.NaN;
    if (i[66] == null) {
      p = 8;
    } else if (((Double) i[66]).doubleValue() <= 0.006525) {
    p = J48WekaClassifier.N694eb05830(i);
    } else if (((Double) i[66]).doubleValue() > 0.006525) {
    p = J48WekaClassifier.N7df60f6f35(i);
    } 
    return p;
  }
  static double N694eb05830(Object []i) {
    double p = Double.NaN;
    if (i[65] == null) {
      p = 8;
    } else if (((Double) i[65]).doubleValue() <= 0.006237) {
    p = J48WekaClassifier.N160b1ccd31(i);
    } else if (((Double) i[65]).doubleValue() > 0.006237) {
    p = J48WekaClassifier.N2f05397433(i);
    } 
    return p;
  }
  static double N160b1ccd31(Object []i) {
    double p = Double.NaN;
    if (i[52] == null) {
      p = 6;
    } else if (((Double) i[52]).doubleValue() <= 0.007969) {
    p = J48WekaClassifier.N3940cefe32(i);
    } else if (((Double) i[52]).doubleValue() > 0.007969) {
      p = 8;
    } 
    return p;
  }
  static double N3940cefe32(Object []i) {
    double p = Double.NaN;
    if (i[0] == null) {
      p = 8;
    } else if (((Double) i[0]).doubleValue() <= 0.090521) {
      p = 8;
    } else if (((Double) i[0]).doubleValue() > 0.090521) {
      p = 6;
    } 
    return p;
  }
  static double N2f05397433(Object []i) {
    double p = Double.NaN;
    if (i[75] == null) {
      p = 22;
    } else if (((Double) i[75]).doubleValue() <= 0.008017) {
    p = J48WekaClassifier.N335590bc34(i);
    } else if (((Double) i[75]).doubleValue() > 0.008017) {
      p = 3;
    } 
    return p;
  }
  static double N335590bc34(Object []i) {
    double p = Double.NaN;
    if (i[43] == null) {
      p = 16;
    } else if (((Double) i[43]).doubleValue() <= 0.006525) {
      p = 16;
    } else if (((Double) i[43]).doubleValue() > 0.006525) {
      p = 22;
    } 
    return p;
  }
  static double N7df60f6f35(Object []i) {
    double p = Double.NaN;
    if (i[51] == null) {
      p = 13;
    } else if (((Double) i[51]).doubleValue() <= 0.00685) {
    p = J48WekaClassifier.N427e091136(i);
    } else if (((Double) i[51]).doubleValue() > 0.00685) {
    p = J48WekaClassifier.N16390f8e39(i);
    } 
    return p;
  }
  static double N427e091136(Object []i) {
    double p = Double.NaN;
    if (i[66] == null) {
      p = 17;
    } else if (((Double) i[66]).doubleValue() <= 0.007966) {
    p = J48WekaClassifier.N443646b337(i);
    } else if (((Double) i[66]).doubleValue() > 0.007966) {
      p = 13;
    } 
    return p;
  }
  static double N443646b337(Object []i) {
    double p = Double.NaN;
    if (i[35] == null) {
      p = 21;
    } else if (((Double) i[35]).doubleValue() <= 0.008533) {
    p = J48WekaClassifier.N5b79eef938(i);
    } else if (((Double) i[35]).doubleValue() > 0.008533) {
      p = 17;
    } 
    return p;
  }
  static double N5b79eef938(Object []i) {
    double p = Double.NaN;
    if (i[12] == null) {
      p = 21;
    } else if (((Double) i[12]).doubleValue() <= 0.007813) {
      p = 21;
    } else if (((Double) i[12]).doubleValue() > 0.007813) {
      p = 6;
    } 
    return p;
  }
  static double N16390f8e39(Object []i) {
    double p = Double.NaN;
    if (i[43] == null) {
      p = 16;
    } else if (((Double) i[43]).doubleValue() <= 0.006087) {
    p = J48WekaClassifier.N243dbad940(i);
    } else if (((Double) i[43]).doubleValue() > 0.006087) {
    p = J48WekaClassifier.N46d251b542(i);
    } 
    return p;
  }
  static double N243dbad940(Object []i) {
    double p = Double.NaN;
    if (i[45] == null) {
      p = 11;
    } else if (((Double) i[45]).doubleValue() <= 0.008006) {
    p = J48WekaClassifier.N52c8633341(i);
    } else if (((Double) i[45]).doubleValue() > 0.008006) {
      p = 16;
    } 
    return p;
  }
  static double N52c8633341(Object []i) {
    double p = Double.NaN;
    if (i[1] == null) {
      p = 15;
    } else if (((Double) i[1]).doubleValue() <= 0.107363) {
      p = 15;
    } else if (((Double) i[1]).doubleValue() > 0.107363) {
      p = 11;
    } 
    return p;
  }
  static double N46d251b542(Object []i) {
    double p = Double.NaN;
    if (i[44] == null) {
      p = 2;
    } else if (((Double) i[44]).doubleValue() <= 0.008599) {
    p = J48WekaClassifier.N1849739e43(i);
    } else if (((Double) i[44]).doubleValue() > 0.008599) {
      p = 24;
    } 
    return p;
  }
  static double N1849739e43(Object []i) {
    double p = Double.NaN;
    if (i[76] == null) {
      p = 2;
    } else if (((Double) i[76]).doubleValue() <= 0.00692) {
      p = 2;
    } else if (((Double) i[76]).doubleValue() > 0.00692) {
    p = J48WekaClassifier.N516be93c44(i);
    } 
    return p;
  }
  static double N516be93c44(Object []i) {
    double p = Double.NaN;
    if (i[30] == null) {
      p = 22;
    } else if (((Double) i[30]).doubleValue() <= 0.007105) {
      p = 22;
    } else if (((Double) i[30]).doubleValue() > 0.007105) {
      p = 11;
    } 
    return p;
  }
  static double N402bd9d945(Object []i) {
    double p = Double.NaN;
    if (i[51] == null) {
      p = 3;
    } else if (((Double) i[51]).doubleValue() <= 0.006447) {
    p = J48WekaClassifier.N1420779046(i);
    } else if (((Double) i[51]).doubleValue() > 0.006447) {
      p = 11;
    } 
    return p;
  }
  static double N1420779046(Object []i) {
    double p = Double.NaN;
    if (i[74] == null) {
      p = 13;
    } else if (((Double) i[74]).doubleValue() <= 0.005488) {
    p = J48WekaClassifier.N47a6230947(i);
    } else if (((Double) i[74]).doubleValue() > 0.005488) {
      p = 3;
    } 
    return p;
  }
  static double N47a6230947(Object []i) {
    double p = Double.NaN;
    if (i[73] == null) {
      p = 10;
    } else if (((Double) i[73]).doubleValue() <= 0.008426) {
    p = J48WekaClassifier.N490a00c848(i);
    } else if (((Double) i[73]).doubleValue() > 0.008426) {
      p = 13;
    } 
    return p;
  }
  static double N490a00c848(Object []i) {
    double p = Double.NaN;
    if (i[40] == null) {
      p = 10;
    } else if (((Double) i[40]).doubleValue() <= 0.00733) {
      p = 10;
    } else if (((Double) i[40]).doubleValue() > 0.00733) {
      p = 21;
    } 
    return p;
  }
  static double N57f1ed2149(Object []i) {
    double p = Double.NaN;
    if (i[54] == null) {
      p = 2;
    } else if (((Double) i[54]).doubleValue() <= 0.004948) {
    p = J48WekaClassifier.N407a9cb850(i);
    } else if (((Double) i[54]).doubleValue() > 0.004948) {
    p = J48WekaClassifier.N77e773ab53(i);
    } 
    return p;
  }
  static double N407a9cb850(Object []i) {
    double p = Double.NaN;
    if (i[50] == null) {
      p = 2;
    } else if (((Double) i[50]).doubleValue() <= 0.007281) {
      p = 2;
    } else if (((Double) i[50]).doubleValue() > 0.007281) {
    p = J48WekaClassifier.N36b251d551(i);
    } 
    return p;
  }
  static double N36b251d551(Object []i) {
    double p = Double.NaN;
    if (i[58] == null) {
      p = 13;
    } else if (((Double) i[58]).doubleValue() <= 0.007544) {
    p = J48WekaClassifier.N2f270b8b52(i);
    } else if (((Double) i[58]).doubleValue() > 0.007544) {
      p = 6;
    } 
    return p;
  }
  static double N2f270b8b52(Object []i) {
    double p = Double.NaN;
    if (i[82] == null) {
      p = 17;
    } else if (((Double) i[82]).doubleValue() <= 0.006173) {
      p = 17;
    } else if (((Double) i[82]).doubleValue() > 0.006173) {
      p = 13;
    } 
    return p;
  }
  static double N77e773ab53(Object []i) {
    double p = Double.NaN;
    if (i[59] == null) {
      p = 6;
    } else if (((Double) i[59]).doubleValue() <= 0.005606) {
    p = J48WekaClassifier.N636cbeb354(i);
    } else if (((Double) i[59]).doubleValue() > 0.005606) {
    p = J48WekaClassifier.N501857c456(i);
    } 
    return p;
  }
  static double N636cbeb354(Object []i) {
    double p = Double.NaN;
    if (i[60] == null) {
      p = 6;
    } else if (((Double) i[60]).doubleValue() <= 0.007625) {
      p = 6;
    } else if (((Double) i[60]).doubleValue() > 0.007625) {
    p = J48WekaClassifier.N477477f255(i);
    } 
    return p;
  }
  static double N477477f255(Object []i) {
    double p = Double.NaN;
    if (i[66] == null) {
      p = 8;
    } else if (((Double) i[66]).doubleValue() <= 0.006084) {
      p = 8;
    } else if (((Double) i[66]).doubleValue() > 0.006084) {
      p = 13;
    } 
    return p;
  }
  static double N501857c456(Object []i) {
    double p = Double.NaN;
    if (i[13] == null) {
      p = 17;
    } else if (((Double) i[13]).doubleValue() <= 0.006613) {
    p = J48WekaClassifier.N1c2e0c4757(i);
    } else if (((Double) i[13]).doubleValue() > 0.006613) {
    p = J48WekaClassifier.N1ab1b05758(i);
    } 
    return p;
  }
  static double N1c2e0c4757(Object []i) {
    double p = Double.NaN;
    if (i[90] == null) {
      p = 17;
    } else if (((Double) i[90]).doubleValue() <= 0.004505) {
      p = 17;
    } else if (((Double) i[90]).doubleValue() > 0.004505) {
      p = 8;
    } 
    return p;
  }
  static double N1ab1b05758(Object []i) {
    double p = Double.NaN;
    if (i[73] == null) {
      p = 15;
    } else if (((Double) i[73]).doubleValue() <= 0.007426) {
      p = 15;
    } else if (((Double) i[73]).doubleValue() > 0.007426) {
    p = J48WekaClassifier.N7e9e9f1459(i);
    } 
    return p;
  }
  static double N7e9e9f1459(Object []i) {
    double p = Double.NaN;
    if (i[57] == null) {
      p = 16;
    } else if (((Double) i[57]).doubleValue() <= 0.008092) {
      p = 16;
    } else if (((Double) i[57]).doubleValue() > 0.008092) {
    p = J48WekaClassifier.N6caa517460(i);
    } 
    return p;
  }
  static double N6caa517460(Object []i) {
    double p = Double.NaN;
    if (i[75] == null) {
      p = 24;
    } else if (((Double) i[75]).doubleValue() <= 0.0082) {
      p = 24;
    } else if (((Double) i[75]).doubleValue() > 0.0082) {
      p = 2;
    } 
    return p;
  }
  static double N8a249261(Object []i) {
    double p = Double.NaN;
    if (i[62] == null) {
      p = 22;
    } else if (((Double) i[62]).doubleValue() <= 0.006517) {
    p = J48WekaClassifier.N172e1fdc62(i);
    } else if (((Double) i[62]).doubleValue() > 0.006517) {
    p = J48WekaClassifier.N1595a80566(i);
    } 
    return p;
  }
  static double N172e1fdc62(Object []i) {
    double p = Double.NaN;
    if (i[53] == null) {
      p = 22;
    } else if (((Double) i[53]).doubleValue() <= 0.005974) {
      p = 22;
    } else if (((Double) i[53]).doubleValue() > 0.005974) {
    p = J48WekaClassifier.N1d42541263(i);
    } 
    return p;
  }
  static double N1d42541263(Object []i) {
    double p = Double.NaN;
    if (i[51] == null) {
      p = 21;
    } else if (((Double) i[51]).doubleValue() <= 0.008291) {
    p = J48WekaClassifier.N235d973f64(i);
    } else if (((Double) i[51]).doubleValue() > 0.008291) {
      p = 24;
    } 
    return p;
  }
  static double N235d973f64(Object []i) {
    double p = Double.NaN;
    if (i[52] == null) {
      p = 21;
    } else if (((Double) i[52]).doubleValue() <= 0.008068) {
      p = 21;
    } else if (((Double) i[52]).doubleValue() > 0.008068) {
    p = J48WekaClassifier.N72a2997265(i);
    } 
    return p;
  }
  static double N72a2997265(Object []i) {
    double p = Double.NaN;
    if (i[43] == null) {
      p = 8;
    } else if (((Double) i[43]).doubleValue() <= 0.008182) {
      p = 8;
    } else if (((Double) i[43]).doubleValue() > 0.008182) {
      p = 17;
    } 
    return p;
  }
  static double N1595a80566(Object []i) {
    double p = Double.NaN;
    if (i[56] == null) {
      p = 8;
    } else if (((Double) i[56]).doubleValue() <= 0.006941) {
    p = J48WekaClassifier.N1af88c6167(i);
    } else if (((Double) i[56]).doubleValue() > 0.006941) {
    p = J48WekaClassifier.N5553146e68(i);
    } 
    return p;
  }
  static double N1af88c6167(Object []i) {
    double p = Double.NaN;
    if (i[43] == null) {
      p = 8;
    } else if (((Double) i[43]).doubleValue() <= 0.008743) {
      p = 8;
    } else if (((Double) i[43]).doubleValue() > 0.008743) {
      p = 18;
    } 
    return p;
  }
  static double N5553146e68(Object []i) {
    double p = Double.NaN;
    if (i[50] == null) {
      p = 2;
    } else if (((Double) i[50]).doubleValue() <= 0.008061) {
    p = J48WekaClassifier.N33dc6ebf69(i);
    } else if (((Double) i[50]).doubleValue() > 0.008061) {
      p = 17;
    } 
    return p;
  }
  static double N33dc6ebf69(Object []i) {
    double p = Double.NaN;
    if (i[0] == null) {
      p = 2;
    } else if (((Double) i[0]).doubleValue() <= 0.08936) {
      p = 2;
    } else if (((Double) i[0]).doubleValue() > 0.08936) {
      p = 0;
    } 
    return p;
  }
  static double Nbb13d4170(Object []i) {
    double p = Double.NaN;
    if (i[52] == null) {
      p = 5;
    } else if (((Double) i[52]).doubleValue() <= 0.00877) {
    p = J48WekaClassifier.N557433d271(i);
    } else if (((Double) i[52]).doubleValue() > 0.00877) {
    p = J48WekaClassifier.N12a3d731164(i);
    } 
    return p;
  }
  static double N557433d271(Object []i) {
    double p = Double.NaN;
    if (i[51] == null) {
      p = 14;
    } else if (((Double) i[51]).doubleValue() <= 0.008429) {
    p = J48WekaClassifier.N18c9bd7672(i);
    } else if (((Double) i[51]).doubleValue() > 0.008429) {
    p = J48WekaClassifier.N20cbc221149(i);
    } 
    return p;
  }
  static double N18c9bd7672(Object []i) {
    double p = Double.NaN;
    if (i[74] == null) {
      p = 21;
    } else if (((Double) i[74]).doubleValue() <= 0.00579) {
    p = J48WekaClassifier.N48b0914673(i);
    } else if (((Double) i[74]).doubleValue() > 0.00579) {
    p = J48WekaClassifier.N180bdca984(i);
    } 
    return p;
  }
  static double N48b0914673(Object []i) {
    double p = Double.NaN;
    if (i[34] == null) {
      p = 21;
    } else if (((Double) i[34]).doubleValue() <= 0.008673) {
    p = J48WekaClassifier.N4ae9f62474(i);
    } else if (((Double) i[34]).doubleValue() > 0.008673) {
    p = J48WekaClassifier.N216fa78d79(i);
    } 
    return p;
  }
  static double N4ae9f62474(Object []i) {
    double p = Double.NaN;
    if (i[53] == null) {
      p = 13;
    } else if (((Double) i[53]).doubleValue() <= 0.005741) {
    p = J48WekaClassifier.N3e77b60875(i);
    } else if (((Double) i[53]).doubleValue() > 0.005741) {
    p = J48WekaClassifier.N6b809ebd76(i);
    } 
    return p;
  }
  static double N3e77b60875(Object []i) {
    double p = Double.NaN;
    if (i[48] == null) {
      p = 13;
    } else if (((Double) i[48]).doubleValue() <= 0.006465) {
      p = 13;
    } else if (((Double) i[48]).doubleValue() > 0.006465) {
      p = 10;
    } 
    return p;
  }
  static double N6b809ebd76(Object []i) {
    double p = Double.NaN;
    if (i[63] == null) {
      p = 20;
    } else if (((Double) i[63]).doubleValue() <= 0.008106) {
    p = J48WekaClassifier.N2776182a77(i);
    } else if (((Double) i[63]).doubleValue() > 0.008106) {
      p = 21;
    } 
    return p;
  }
  static double N2776182a77(Object []i) {
    double p = Double.NaN;
    if (i[57] == null) {
      p = 20;
    } else if (((Double) i[57]).doubleValue() <= 0.006718) {
      p = 20;
    } else if (((Double) i[57]).doubleValue() > 0.006718) {
    p = J48WekaClassifier.N222b923678(i);
    } 
    return p;
  }
  static double N222b923678(Object []i) {
    double p = Double.NaN;
    if (i[15] == null) {
      p = 18;
    } else if (((Double) i[15]).doubleValue() <= 0.006836) {
      p = 18;
    } else if (((Double) i[15]).doubleValue() > 0.006836) {
      p = 25;
    } 
    return p;
  }
  static double N216fa78d79(Object []i) {
    double p = Double.NaN;
    if (i[64] == null) {
      p = 12;
    } else if (((Double) i[64]).doubleValue() <= 0.009053) {
    p = J48WekaClassifier.N4ef5b06b80(i);
    } else if (((Double) i[64]).doubleValue() > 0.009053) {
    p = J48WekaClassifier.N2711c5f982(i);
    } 
    return p;
  }
  static double N4ef5b06b80(Object []i) {
    double p = Double.NaN;
    if (i[52] == null) {
      p = 12;
    } else if (((Double) i[52]).doubleValue() <= 0.006313) {
      p = 12;
    } else if (((Double) i[52]).doubleValue() > 0.006313) {
    p = J48WekaClassifier.N59d546d781(i);
    } 
    return p;
  }
  static double N59d546d781(Object []i) {
    double p = Double.NaN;
    if (i[0] == null) {
      p = 7;
    } else if (((Double) i[0]).doubleValue() <= 0.077723) {
      p = 7;
    } else if (((Double) i[0]).doubleValue() > 0.077723) {
      p = 21;
    } 
    return p;
  }
  static double N2711c5f982(Object []i) {
    double p = Double.NaN;
    if (i[33] == null) {
      p = 3;
    } else if (((Double) i[33]).doubleValue() <= 0.007399) {
      p = 3;
    } else if (((Double) i[33]).doubleValue() > 0.007399) {
    p = J48WekaClassifier.N7b9e4d5983(i);
    } 
    return p;
  }
  static double N7b9e4d5983(Object []i) {
    double p = Double.NaN;
    if (i[20] == null) {
      p = 19;
    } else if (((Double) i[20]).doubleValue() <= 9.77E-4) {
      p = 19;
    } else if (((Double) i[20]).doubleValue() > 9.77E-4) {
      p = 22;
    } 
    return p;
  }
  static double N180bdca984(Object []i) {
    double p = Double.NaN;
    if (i[1] == null) {
      p = 14;
    } else if (((Double) i[1]).doubleValue() <= 0.10263) {
    p = J48WekaClassifier.N6b9bd28185(i);
    } else if (((Double) i[1]).doubleValue() > 0.10263) {
    p = J48WekaClassifier.N38e3222889(i);
    } 
    return p;
  }
  static double N6b9bd28185(Object []i) {
    double p = Double.NaN;
    if (i[73] == null) {
      p = 21;
    } else if (((Double) i[73]).doubleValue() <= 0.007382) {
    p = J48WekaClassifier.N428cfc0686(i);
    } else if (((Double) i[73]).doubleValue() > 0.007382) {
    p = J48WekaClassifier.Ndd9e6c888(i);
    } 
    return p;
  }
  static double N428cfc0686(Object []i) {
    double p = Double.NaN;
    if (i[35] == null) {
      p = 19;
    } else if (((Double) i[35]).doubleValue() <= 0.007159) {
    p = J48WekaClassifier.N4bf1958b87(i);
    } else if (((Double) i[35]).doubleValue() > 0.007159) {
      p = 21;
    } 
    return p;
  }
  static double N4bf1958b87(Object []i) {
    double p = Double.NaN;
    if (i[61] == null) {
      p = 19;
    } else if (((Double) i[61]).doubleValue() <= 0.007291) {
      p = 19;
    } else if (((Double) i[61]).doubleValue() > 0.007291) {
      p = 5;
    } 
    return p;
  }
  static double Ndd9e6c888(Object []i) {
    double p = Double.NaN;
    if (i[34] == null) {
      p = 14;
    } else if (((Double) i[34]).doubleValue() <= 0.007131) {
      p = 14;
    } else if (((Double) i[34]).doubleValue() > 0.007131) {
      p = 1;
    } 
    return p;
  }
  static double N38e3222889(Object []i) {
    double p = Double.NaN;
    if (i[54] == null) {
      p = 18;
    } else if (((Double) i[54]).doubleValue() <= 0.00709) {
    p = J48WekaClassifier.N1d2a95fe90(i);
    } else if (((Double) i[54]).doubleValue() > 0.00709) {
    p = J48WekaClassifier.N172cdce697(i);
    } 
    return p;
  }
  static double N1d2a95fe90(Object []i) {
    double p = Double.NaN;
    if (i[61] == null) {
      p = 19;
    } else if (((Double) i[61]).doubleValue() <= 0.006883) {
    p = J48WekaClassifier.N5ab0061d91(i);
    } else if (((Double) i[61]).doubleValue() > 0.006883) {
    p = J48WekaClassifier.N708230de94(i);
    } 
    return p;
  }
  static double N5ab0061d91(Object []i) {
    double p = Double.NaN;
    if (i[63] == null) {
      p = 19;
    } else if (((Double) i[63]).doubleValue() <= 0.008181) {
      p = 19;
    } else if (((Double) i[63]).doubleValue() > 0.008181) {
    p = J48WekaClassifier.N181d542592(i);
    } 
    return p;
  }
  static double N181d542592(Object []i) {
    double p = Double.NaN;
    if (i[49] == null) {
      p = 3;
    } else if (((Double) i[49]).doubleValue() <= 0.00949) {
    p = J48WekaClassifier.N394ed76c93(i);
    } else if (((Double) i[49]).doubleValue() > 0.00949) {
      p = 7;
    } 
    return p;
  }
  static double N394ed76c93(Object []i) {
    double p = Double.NaN;
    if (i[49] == null) {
      p = 3;
    } else if (((Double) i[49]).doubleValue() <= 0.006116) {
      p = 3;
    } else if (((Double) i[49]).doubleValue() > 0.006116) {
      p = 21;
    } 
    return p;
  }
  static double N708230de94(Object []i) {
    double p = Double.NaN;
    if (i[62] == null) {
      p = 14;
    } else if (((Double) i[62]).doubleValue() <= 0.006886) {
      p = 14;
    } else if (((Double) i[62]).doubleValue() > 0.006886) {
    p = J48WekaClassifier.N2a58503d95(i);
    } 
    return p;
  }
  static double N2a58503d95(Object []i) {
    double p = Double.NaN;
    if (i[34] == null) {
      p = 18;
    } else if (((Double) i[34]).doubleValue() <= 0.00735) {
      p = 18;
    } else if (((Double) i[34]).doubleValue() > 0.00735) {
    p = J48WekaClassifier.N5896952f96(i);
    } 
    return p;
  }
  static double N5896952f96(Object []i) {
    double p = Double.NaN;
    if (i[1] == null) {
      p = 11;
    } else if (((Double) i[1]).doubleValue() <= 0.114718) {
      p = 11;
    } else if (((Double) i[1]).doubleValue() > 0.114718) {
      p = 6;
    } 
    return p;
  }
  static double N172cdce697(Object []i) {
    double p = Double.NaN;
    if (i[23] == null) {
      p = 7;
    } else if (((Double) i[23]).doubleValue() <= 0.006482) {
    p = J48WekaClassifier.N76491a1d98(i);
    } else if (((Double) i[23]).doubleValue() > 0.006482) {
    p = J48WekaClassifier.N19f43946110(i);
    } 
    return p;
  }
  static double N76491a1d98(Object []i) {
    double p = Double.NaN;
    if (i[61] == null) {
      p = 7;
    } else if (((Double) i[61]).doubleValue() <= 0.007039) {
    p = J48WekaClassifier.N1e78755199(i);
    } else if (((Double) i[61]).doubleValue() > 0.007039) {
    p = J48WekaClassifier.N4069fafe105(i);
    } 
    return p;
  }
  static double N1e78755199(Object []i) {
    double p = Double.NaN;
    if (i[53] == null) {
      p = 22;
    } else if (((Double) i[53]).doubleValue() <= 0.007354) {
    p = J48WekaClassifier.N72abb45c100(i);
    } else if (((Double) i[53]).doubleValue() > 0.007354) {
    p = J48WekaClassifier.N3db6f68e102(i);
    } 
    return p;
  }
  static double N72abb45c100(Object []i) {
    double p = Double.NaN;
    if (i[44] == null) {
      p = 22;
    } else if (((Double) i[44]).doubleValue() <= 0.007586) {
      p = 22;
    } else if (((Double) i[44]).doubleValue() > 0.007586) {
    p = J48WekaClassifier.N3119d03101(i);
    } 
    return p;
  }
  static double N3119d03101(Object []i) {
    double p = Double.NaN;
    if (i[52] == null) {
      p = 14;
    } else if (((Double) i[52]).doubleValue() <= 0.005046) {
      p = 14;
    } else if (((Double) i[52]).doubleValue() > 0.005046) {
      p = 3;
    } 
    return p;
  }
  static double N3db6f68e102(Object []i) {
    double p = Double.NaN;
    if (i[53] == null) {
      p = 7;
    } else if (((Double) i[53]).doubleValue() <= 0.012699) {
    p = J48WekaClassifier.N6039de94103(i);
    } else if (((Double) i[53]).doubleValue() > 0.012699) {
      p = 19;
    } 
    return p;
  }
  static double N6039de94103(Object []i) {
    double p = Double.NaN;
    if (i[54] == null) {
      p = 7;
    } else if (((Double) i[54]).doubleValue() <= 0.011142) {
      p = 7;
    } else if (((Double) i[54]).doubleValue() > 0.011142) {
    p = J48WekaClassifier.N4f1f8f9b104(i);
    } 
    return p;
  }
  static double N4f1f8f9b104(Object []i) {
    double p = Double.NaN;
    if (i[1] == null) {
      p = 21;
    } else if (((Double) i[1]).doubleValue() <= 0.116524) {
      p = 21;
    } else if (((Double) i[1]).doubleValue() > 0.116524) {
      p = 3;
    } 
    return p;
  }
  static double N4069fafe105(Object []i) {
    double p = Double.NaN;
    if (i[64] == null) {
      p = 12;
    } else if (((Double) i[64]).doubleValue() <= 0.007465) {
    p = J48WekaClassifier.N4ae166fb106(i);
    } else if (((Double) i[64]).doubleValue() > 0.007465) {
    p = J48WekaClassifier.N6482dc4d107(i);
    } 
    return p;
  }
  static double N4ae166fb106(Object []i) {
    double p = Double.NaN;
    if (i[66] == null) {
      p = 12;
    } else if (((Double) i[66]).doubleValue() <= 0.008119) {
      p = 12;
    } else if (((Double) i[66]).doubleValue() > 0.008119) {
      p = 23;
    } 
    return p;
  }
  static double N6482dc4d107(Object []i) {
    double p = Double.NaN;
    if (i[73] == null) {
      p = 5;
    } else if (((Double) i[73]).doubleValue() <= 0.008068) {
      p = 5;
    } else if (((Double) i[73]).doubleValue() > 0.008068) {
    p = J48WekaClassifier.N5752f411108(i);
    } 
    return p;
  }
  static double N5752f411108(Object []i) {
    double p = Double.NaN;
    if (i[61] == null) {
      p = 20;
    } else if (((Double) i[61]).doubleValue() <= 0.008834) {
    p = J48WekaClassifier.N58634a0f109(i);
    } else if (((Double) i[61]).doubleValue() > 0.008834) {
      p = 1;
    } 
    return p;
  }
  static double N58634a0f109(Object []i) {
    double p = Double.NaN;
    if (i[13] == null) {
      p = 7;
    } else if (((Double) i[13]).doubleValue() <= 0.006613) {
      p = 7;
    } else if (((Double) i[13]).doubleValue() > 0.006613) {
      p = 20;
    } 
    return p;
  }
  static double N19f43946110(Object []i) {
    double p = Double.NaN;
    if (i[57] == null) {
      p = 20;
    } else if (((Double) i[57]).doubleValue() <= 0.007578) {
    p = J48WekaClassifier.N6b66fe81111(i);
    } else if (((Double) i[57]).doubleValue() > 0.007578) {
    p = J48WekaClassifier.N24294c6c130(i);
    } 
    return p;
  }
  static double N6b66fe81111(Object []i) {
    double p = Double.NaN;
    if (i[33] == null) {
      p = 20;
    } else if (((Double) i[33]).doubleValue() <= 0.00723) {
    p = J48WekaClassifier.N2b547d80112(i);
    } else if (((Double) i[33]).doubleValue() > 0.00723) {
    p = J48WekaClassifier.N21d1cfb120(i);
    } 
    return p;
  }
  static double N2b547d80112(Object []i) {
    double p = Double.NaN;
    if (i[86] == null) {
      p = 3;
    } else if (((Double) i[86]).doubleValue() <= 0.007614) {
    p = J48WekaClassifier.N69a569d7113(i);
    } else if (((Double) i[86]).doubleValue() > 0.007614) {
    p = J48WekaClassifier.Nd6d3def115(i);
    } 
    return p;
  }
  static double N69a569d7113(Object []i) {
    double p = Double.NaN;
    if (i[97] == null) {
      p = 3;
    } else if (((Double) i[97]).doubleValue() <= 0.007122) {
      p = 3;
    } else if (((Double) i[97]).doubleValue() > 0.007122) {
    p = J48WekaClassifier.N51a353ac114(i);
    } 
    return p;
  }
  static double N51a353ac114(Object []i) {
    double p = Double.NaN;
    if (i[24] == null) {
      p = 25;
    } else if (((Double) i[24]).doubleValue() <= 0.00684) {
      p = 25;
    } else if (((Double) i[24]).doubleValue() > 0.00684) {
      p = 19;
    } 
    return p;
  }
  static double Nd6d3def115(Object []i) {
    double p = Double.NaN;
    if (i[43] == null) {
      p = 1;
    } else if (((Double) i[43]).doubleValue() <= 0.006623) {
    p = J48WekaClassifier.N5ddf9bf116(i);
    } else if (((Double) i[43]).doubleValue() > 0.006623) {
    p = J48WekaClassifier.Nc01c673118(i);
    } 
    return p;
  }
  static double N5ddf9bf116(Object []i) {
    double p = Double.NaN;
    if (i[10] == null) {
      p = 10;
    } else if (((Double) i[10]).doubleValue() <= 0.00517) {
      p = 10;
    } else if (((Double) i[10]).doubleValue() > 0.00517) {
    p = J48WekaClassifier.N4774c302117(i);
    } 
    return p;
  }
  static double N4774c302117(Object []i) {
    double p = Double.NaN;
    if (i[33] == null) {
      p = 9;
    } else if (((Double) i[33]).doubleValue() <= 0.006961) {
      p = 9;
    } else if (((Double) i[33]).doubleValue() > 0.006961) {
      p = 1;
    } 
    return p;
  }
  static double Nc01c673118(Object []i) {
    double p = Double.NaN;
    if (i[24] == null) {
      p = 22;
    } else if (((Double) i[24]).doubleValue() <= 0.006008) {
    p = J48WekaClassifier.N68e70059119(i);
    } else if (((Double) i[24]).doubleValue() > 0.006008) {
      p = 20;
    } 
    return p;
  }
  static double N68e70059119(Object []i) {
    double p = Double.NaN;
    if (i[33] == null) {
      p = 5;
    } else if (((Double) i[33]).doubleValue() <= 0.006199) {
      p = 5;
    } else if (((Double) i[33]).doubleValue() > 0.006199) {
      p = 22;
    } 
    return p;
  }
  static double N21d1cfb120(Object []i) {
    double p = Double.NaN;
    if (i[44] == null) {
      p = 19;
    } else if (((Double) i[44]).doubleValue() <= 0.00873) {
    p = J48WekaClassifier.N6390b369121(i);
    } else if (((Double) i[44]).doubleValue() > 0.00873) {
    p = J48WekaClassifier.N44298c2b127(i);
    } 
    return p;
  }
  static double N6390b369121(Object []i) {
    double p = Double.NaN;
    if (i[53] == null) {
      p = 22;
    } else if (((Double) i[53]).doubleValue() <= 0.008276) {
    p = J48WekaClassifier.N61a0d336122(i);
    } else if (((Double) i[53]).doubleValue() > 0.008276) {
    p = J48WekaClassifier.N3d68316c125(i);
    } 
    return p;
  }
  static double N61a0d336122(Object []i) {
    double p = Double.NaN;
    if (i[83] == null) {
      p = 1;
    } else if (((Double) i[83]).doubleValue() <= 0.009213) {
    p = J48WekaClassifier.N3115f293123(i);
    } else if (((Double) i[83]).doubleValue() > 0.009213) {
      p = 22;
    } 
    return p;
  }
  static double N3115f293123(Object []i) {
    double p = Double.NaN;
    if (i[51] == null) {
      p = 1;
    } else if (((Double) i[51]).doubleValue() <= 0.00693) {
      p = 1;
    } else if (((Double) i[51]).doubleValue() > 0.00693) {
    p = J48WekaClassifier.N5b85ca8e124(i);
    } 
    return p;
  }
  static double N5b85ca8e124(Object []i) {
    double p = Double.NaN;
    if (i[1] == null) {
      p = 16;
    } else if (((Double) i[1]).doubleValue() <= 0.108486) {
      p = 16;
    } else if (((Double) i[1]).doubleValue() > 0.108486) {
      p = 7;
    } 
    return p;
  }
  static double N3d68316c125(Object []i) {
    double p = Double.NaN;
    if (i[64] == null) {
      p = 25;
    } else if (((Double) i[64]).doubleValue() <= 0.006886) {
    p = J48WekaClassifier.N5a367c94126(i);
    } else if (((Double) i[64]).doubleValue() > 0.006886) {
      p = 19;
    } 
    return p;
  }
  static double N5a367c94126(Object []i) {
    double p = Double.NaN;
    if (i[60] == null) {
      p = 7;
    } else if (((Double) i[60]).doubleValue() <= 0.006018) {
      p = 7;
    } else if (((Double) i[60]).doubleValue() > 0.006018) {
      p = 25;
    } 
    return p;
  }
  static double N44298c2b127(Object []i) {
    double p = Double.NaN;
    if (i[62] == null) {
      p = 20;
    } else if (((Double) i[62]).doubleValue() <= 0.007453) {
      p = 20;
    } else if (((Double) i[62]).doubleValue() > 0.007453) {
    p = J48WekaClassifier.N318def9a128(i);
    } 
    return p;
  }
  static double N318def9a128(Object []i) {
    double p = Double.NaN;
    if (i[68] == null) {
      p = 12;
    } else if (((Double) i[68]).doubleValue() <= 0.005726) {
      p = 12;
    } else if (((Double) i[68]).doubleValue() > 0.005726) {
    p = J48WekaClassifier.N4d925b96129(i);
    } 
    return p;
  }
  static double N4d925b96129(Object []i) {
    double p = Double.NaN;
    if (i[1] == null) {
      p = 16;
    } else if (((Double) i[1]).doubleValue() <= 0.11376) {
      p = 16;
    } else if (((Double) i[1]).doubleValue() > 0.11376) {
      p = 3;
    } 
    return p;
  }
  static double N24294c6c130(Object []i) {
    double p = Double.NaN;
    if (i[24] == null) {
      p = 1;
    } else if (((Double) i[24]).doubleValue() <= 0.007864) {
    p = J48WekaClassifier.N2c69c416131(i);
    } else if (((Double) i[24]).doubleValue() > 0.007864) {
    p = J48WekaClassifier.N73c2a104137(i);
    } 
    return p;
  }
  static double N2c69c416131(Object []i) {
    double p = Double.NaN;
    if (i[94] == null) {
      p = 1;
    } else if (((Double) i[94]).doubleValue() <= 0.006702) {
    p = J48WekaClassifier.N72c61f3e132(i);
    } else if (((Double) i[94]).doubleValue() > 0.006702) {
    p = J48WekaClassifier.N4373d7e1134(i);
    } 
    return p;
  }
  static double N72c61f3e132(Object []i) {
    double p = Double.NaN;
    if (i[34] == null) {
      p = 18;
    } else if (((Double) i[34]).doubleValue() <= 0.007992) {
    p = J48WekaClassifier.N2dd7a41b133(i);
    } else if (((Double) i[34]).doubleValue() > 0.007992) {
      p = 1;
    } 
    return p;
  }
  static double N2dd7a41b133(Object []i) {
    double p = Double.NaN;
    if (i[48] == null) {
      p = 18;
    } else if (((Double) i[48]).doubleValue() <= 0.007405) {
      p = 18;
    } else if (((Double) i[48]).doubleValue() > 0.007405) {
      p = 5;
    } 
    return p;
  }
  static double N4373d7e1134(Object []i) {
    double p = Double.NaN;
    if (i[55] == null) {
      p = 24;
    } else if (((Double) i[55]).doubleValue() <= 0.007401) {
    p = J48WekaClassifier.N21d8e2ed135(i);
    } else if (((Double) i[55]).doubleValue() > 0.007401) {
    p = J48WekaClassifier.N63252607136(i);
    } 
    return p;
  }
  static double N21d8e2ed135(Object []i) {
    double p = Double.NaN;
    if (i[14] == null) {
      p = 4;
    } else if (((Double) i[14]).doubleValue() <= 0.006112) {
      p = 4;
    } else if (((Double) i[14]).doubleValue() > 0.006112) {
      p = 24;
    } 
    return p;
  }
  static double N63252607136(Object []i) {
    double p = Double.NaN;
    if (i[77] == null) {
      p = 12;
    } else if (((Double) i[77]).doubleValue() <= 0.007243) {
      p = 12;
    } else if (((Double) i[77]).doubleValue() > 0.007243) {
      p = 22;
    } 
    return p;
  }
  static double N73c2a104137(Object []i) {
    double p = Double.NaN;
    if (i[49] == null) {
      p = 3;
    } else if (((Double) i[49]).doubleValue() <= 0.00689) {
    p = J48WekaClassifier.N2ed3bc42138(i);
    } else if (((Double) i[49]).doubleValue() > 0.00689) {
    p = J48WekaClassifier.N578b2457142(i);
    } 
    return p;
  }
  static double N2ed3bc42138(Object []i) {
    double p = Double.NaN;
    if (i[7] == null) {
      p = 9;
    } else if (((Double) i[7]).doubleValue() <= 0.102507) {
    p = J48WekaClassifier.N487aecff139(i);
    } else if (((Double) i[7]).doubleValue() > 0.102507) {
    p = J48WekaClassifier.N225fee9140(i);
    } 
    return p;
  }
  static double N487aecff139(Object []i) {
    double p = Double.NaN;
    if (i[20] == null) {
      p = 9;
    } else if (((Double) i[20]).doubleValue() <= 0.003553) {
      p = 9;
    } else if (((Double) i[20]).doubleValue() > 0.003553) {
      p = 23;
    } 
    return p;
  }
  static double N225fee9140(Object []i) {
    double p = Double.NaN;
    if (i[65] == null) {
      p = 10;
    } else if (((Double) i[65]).doubleValue() <= 0.006753) {
    p = J48WekaClassifier.N6489a528141(i);
    } else if (((Double) i[65]).doubleValue() > 0.006753) {
      p = 3;
    } 
    return p;
  }
  static double N6489a528141(Object []i) {
    double p = Double.NaN;
    if (i[0] == null) {
      p = 10;
    } else if (((Double) i[0]).doubleValue() <= 0.078651) {
      p = 10;
    } else if (((Double) i[0]).doubleValue() > 0.078651) {
      p = 21;
    } 
    return p;
  }
  static double N578b2457142(Object []i) {
    double p = Double.NaN;
    if (i[60] == null) {
      p = 9;
    } else if (((Double) i[60]).doubleValue() <= 0.007211) {
    p = J48WekaClassifier.N4889374d143(i);
    } else if (((Double) i[60]).doubleValue() > 0.007211) {
    p = J48WekaClassifier.N42d82f24146(i);
    } 
    return p;
  }
  static double N4889374d143(Object []i) {
    double p = Double.NaN;
    if (i[23] == null) {
      p = 7;
    } else if (((Double) i[23]).doubleValue() <= 0.008214) {
    p = J48WekaClassifier.N65f64a03144(i);
    } else if (((Double) i[23]).doubleValue() > 0.008214) {
    p = J48WekaClassifier.N4cff0370145(i);
    } 
    return p;
  }
  static double N65f64a03144(Object []i) {
    double p = Double.NaN;
    if (i[64] == null) {
      p = 3;
    } else if (((Double) i[64]).doubleValue() <= 0.008271) {
      p = 3;
    } else if (((Double) i[64]).doubleValue() > 0.008271) {
      p = 7;
    } 
    return p;
  }
  static double N4cff0370145(Object []i) {
    double p = Double.NaN;
    if (i[54] == null) {
      p = 6;
    } else if (((Double) i[54]).doubleValue() <= 0.008085) {
      p = 6;
    } else if (((Double) i[54]).doubleValue() > 0.008085) {
      p = 9;
    } 
    return p;
  }
  static double N42d82f24146(Object []i) {
    double p = Double.NaN;
    if (i[51] == null) {
      p = 10;
    } else if (((Double) i[51]).doubleValue() <= 0.007091) {
    p = J48WekaClassifier.N436a4b6d147(i);
    } else if (((Double) i[51]).doubleValue() > 0.007091) {
      p = 5;
    } 
    return p;
  }
  static double N436a4b6d147(Object []i) {
    double p = Double.NaN;
    if (i[76] == null) {
      p = 8;
    } else if (((Double) i[76]).doubleValue() <= 0.008948) {
    p = J48WekaClassifier.N141ba751148(i);
    } else if (((Double) i[76]).doubleValue() > 0.008948) {
      p = 10;
    } 
    return p;
  }
  static double N141ba751148(Object []i) {
    double p = Double.NaN;
    if (i[12] == null) {
      p = 8;
    } else if (((Double) i[12]).doubleValue() <= 0.007328) {
      p = 8;
    } else if (((Double) i[12]).doubleValue() > 0.007328) {
      p = 20;
    } 
    return p;
  }
  static double N20cbc221149(Object []i) {
    double p = Double.NaN;
    if (i[61] == null) {
      p = 0;
    } else if (((Double) i[61]).doubleValue() <= 0.008054) {
    p = J48WekaClassifier.N23e96813150(i);
    } else if (((Double) i[61]).doubleValue() > 0.008054) {
    p = J48WekaClassifier.N7c7c701a160(i);
    } 
    return p;
  }
  static double N23e96813150(Object []i) {
    double p = Double.NaN;
    if (i[8] == null) {
      p = 0;
    } else if (((Double) i[8]).doubleValue() <= 0.093738) {
    p = J48WekaClassifier.N32496e20151(i);
    } else if (((Double) i[8]).doubleValue() > 0.093738) {
    p = J48WekaClassifier.N5056988153(i);
    } 
    return p;
  }
  static double N32496e20151(Object []i) {
    double p = Double.NaN;
    if (i[43] == null) {
      p = 7;
    } else if (((Double) i[43]).doubleValue() <= 0.008245) {
    p = J48WekaClassifier.N7ba16617152(i);
    } else if (((Double) i[43]).doubleValue() > 0.008245) {
      p = 0;
    } 
    return p;
  }
  static double N7ba16617152(Object []i) {
    double p = Double.NaN;
    if (i[12] == null) {
      p = 19;
    } else if (((Double) i[12]).doubleValue() <= 0.003545) {
      p = 19;
    } else if (((Double) i[12]).doubleValue() > 0.003545) {
      p = 7;
    } 
    return p;
  }
  static double N5056988153(Object []i) {
    double p = Double.NaN;
    if (i[57] == null) {
      p = 19;
    } else if (((Double) i[57]).doubleValue() <= 0.007384) {
    p = J48WekaClassifier.N6d4420cb154(i);
    } else if (((Double) i[57]).doubleValue() > 0.007384) {
    p = J48WekaClassifier.N4a834a49157(i);
    } 
    return p;
  }
  static double N6d4420cb154(Object []i) {
    double p = Double.NaN;
    if (i[53] == null) {
      p = 22;
    } else if (((Double) i[53]).doubleValue() <= 0.009267) {
    p = J48WekaClassifier.N14057b2d155(i);
    } else if (((Double) i[53]).doubleValue() > 0.009267) {
      p = 19;
    } 
    return p;
  }
  static double N14057b2d155(Object []i) {
    double p = Double.NaN;
    if (i[20] == null) {
      p = 22;
    } else if (((Double) i[20]).doubleValue() <= 0.005927) {
      p = 22;
    } else if (((Double) i[20]).doubleValue() > 0.005927) {
    p = J48WekaClassifier.N64643664156(i);
    } 
    return p;
  }
  static double N64643664156(Object []i) {
    double p = Double.NaN;
    if (i[0] == null) {
      p = 17;
    } else if (((Double) i[0]).doubleValue() <= 0.086575) {
      p = 17;
    } else if (((Double) i[0]).doubleValue() > 0.086575) {
      p = 0;
    } 
    return p;
  }
  static double N4a834a49157(Object []i) {
    double p = Double.NaN;
    if (i[63] == null) {
      p = 9;
    } else if (((Double) i[63]).doubleValue() <= 0.008227) {
      p = 9;
    } else if (((Double) i[63]).doubleValue() > 0.008227) {
    p = J48WekaClassifier.N68d79aa158(i);
    } 
    return p;
  }
  static double N68d79aa158(Object []i) {
    double p = Double.NaN;
    if (i[12] == null) {
      p = 7;
    } else if (((Double) i[12]).doubleValue() <= 0.006115) {
      p = 7;
    } else if (((Double) i[12]).doubleValue() > 0.006115) {
    p = J48WekaClassifier.N396eb645159(i);
    } 
    return p;
  }
  static double N396eb645159(Object []i) {
    double p = Double.NaN;
    if (i[0] == null) {
      p = 4;
    } else if (((Double) i[0]).doubleValue() <= 0.085882) {
      p = 4;
    } else if (((Double) i[0]).doubleValue() > 0.085882) {
      p = 11;
    } 
    return p;
  }
  static double N7c7c701a160(Object []i) {
    double p = Double.NaN;
    if (i[64] == null) {
      p = 23;
    } else if (((Double) i[64]).doubleValue() <= 0.008977) {
    p = J48WekaClassifier.N2cfdbcde161(i);
    } else if (((Double) i[64]).doubleValue() > 0.008977) {
    p = J48WekaClassifier.Nd409a23163(i);
    } 
    return p;
  }
  static double N2cfdbcde161(Object []i) {
    double p = Double.NaN;
    if (i[7] == null) {
      p = 23;
    } else if (((Double) i[7]).doubleValue() <= 0.109249) {
      p = 23;
    } else if (((Double) i[7]).doubleValue() > 0.109249) {
    p = J48WekaClassifier.N41d0c0c2162(i);
    } 
    return p;
  }
  static double N41d0c0c2162(Object []i) {
    double p = Double.NaN;
    if (i[63] == null) {
      p = 24;
    } else if (((Double) i[63]).doubleValue() <= 0.006858) {
      p = 24;
    } else if (((Double) i[63]).doubleValue() > 0.006858) {
      p = 11;
    } 
    return p;
  }
  static double Nd409a23163(Object []i) {
    double p = Double.NaN;
    if (i[22] == null) {
      p = 5;
    } else if (((Double) i[22]).doubleValue() <= 0.009959) {
      p = 5;
    } else if (((Double) i[22]).doubleValue() > 0.009959) {
      p = 0;
    } 
    return p;
  }
  static double N12a3d731164(Object []i) {
    double p = Double.NaN;
    if (i[43] == null) {
      p = 1;
    } else if (((Double) i[43]).doubleValue() <= 0.006184) {
    p = J48WekaClassifier.N53f992f7165(i);
    } else if (((Double) i[43]).doubleValue() > 0.006184) {
    p = J48WekaClassifier.N47cff5c3171(i);
    } 
    return p;
  }
  static double N53f992f7165(Object []i) {
    double p = Double.NaN;
    if (i[94] == null) {
      p = 1;
    } else if (((Double) i[94]).doubleValue() <= 0.004649) {
    p = J48WekaClassifier.N14688e9a166(i);
    } else if (((Double) i[94]).doubleValue() > 0.004649) {
    p = J48WekaClassifier.N1d708fb6167(i);
    } 
    return p;
  }
  static double N14688e9a166(Object []i) {
    double p = Double.NaN;
    if (i[59] == null) {
      p = 1;
    } else if (((Double) i[59]).doubleValue() <= 0.008209) {
      p = 1;
    } else if (((Double) i[59]).doubleValue() > 0.008209) {
      p = 25;
    } 
    return p;
  }
  static double N1d708fb6167(Object []i) {
    double p = Double.NaN;
    if (i[55] == null) {
      p = 15;
    } else if (((Double) i[55]).doubleValue() <= 0.008158) {
    p = J48WekaClassifier.N11e6c976168(i);
    } else if (((Double) i[55]).doubleValue() > 0.008158) {
      p = 16;
    } 
    return p;
  }
  static double N11e6c976168(Object []i) {
    double p = Double.NaN;
    if (i[54] == null) {
      p = 11;
    } else if (((Double) i[54]).doubleValue() <= 0.008182) {
    p = J48WekaClassifier.Ne979f97169(i);
    } else if (((Double) i[54]).doubleValue() > 0.008182) {
      p = 15;
    } 
    return p;
  }
  static double Ne979f97169(Object []i) {
    double p = Double.NaN;
    if (i[23] == null) {
      p = 11;
    } else if (((Double) i[23]).doubleValue() <= 0.00948) {
      p = 11;
    } else if (((Double) i[23]).doubleValue() > 0.00948) {
    p = J48WekaClassifier.N5e5bcc81170(i);
    } 
    return p;
  }
  static double N5e5bcc81170(Object []i) {
    double p = Double.NaN;
    if (i[87] == null) {
      p = 2;
    } else if (((Double) i[87]).doubleValue() <= 0.008056) {
      p = 2;
    } else if (((Double) i[87]).doubleValue() > 0.008056) {
      p = 6;
    } 
    return p;
  }
  static double N47cff5c3171(Object []i) {
    double p = Double.NaN;
    if (i[65] == null) {
      p = 8;
    } else if (((Double) i[65]).doubleValue() <= 0.004503) {
    p = J48WekaClassifier.N60c53935172(i);
    } else if (((Double) i[65]).doubleValue() > 0.004503) {
    p = J48WekaClassifier.N529c799d173(i);
    } 
    return p;
  }
  static double N60c53935172(Object []i) {
    double p = Double.NaN;
    if (i[53] == null) {
      p = 8;
    } else if (((Double) i[53]).doubleValue() <= 0.007059) {
      p = 8;
    } else if (((Double) i[53]).doubleValue() > 0.007059) {
      p = 11;
    } 
    return p;
  }
  static double N529c799d173(Object []i) {
    double p = Double.NaN;
    if (i[62] == null) {
      p = 25;
    } else if (((Double) i[62]).doubleValue() <= 0.007209) {
    p = J48WekaClassifier.N5223888b174(i);
    } else if (((Double) i[62]).doubleValue() > 0.007209) {
    p = J48WekaClassifier.N5cf7ee71178(i);
    } 
    return p;
  }
  static double N5223888b174(Object []i) {
    double p = Double.NaN;
    if (i[53] == null) {
      p = 22;
    } else if (((Double) i[53]).doubleValue() <= 0.007836) {
      p = 22;
    } else if (((Double) i[53]).doubleValue() > 0.007836) {
    p = J48WekaClassifier.N6afa1ee1175(i);
    } 
    return p;
  }
  static double N6afa1ee1175(Object []i) {
    double p = Double.NaN;
    if (i[51] == null) {
      p = 25;
    } else if (((Double) i[51]).doubleValue() <= 0.006904) {
      p = 25;
    } else if (((Double) i[51]).doubleValue() > 0.006904) {
    p = J48WekaClassifier.N23bf8e1a176(i);
    } 
    return p;
  }
  static double N23bf8e1a176(Object []i) {
    double p = Double.NaN;
    if (i[73] == null) {
      p = 22;
    } else if (((Double) i[73]).doubleValue() <= 0.002369) {
      p = 22;
    } else if (((Double) i[73]).doubleValue() > 0.002369) {
    p = J48WekaClassifier.N125e4b61177(i);
    } 
    return p;
  }
  static double N125e4b61177(Object []i) {
    double p = Double.NaN;
    if (i[59] == null) {
      p = 19;
    } else if (((Double) i[59]).doubleValue() <= 0.007021) {
      p = 19;
    } else if (((Double) i[59]).doubleValue() > 0.007021) {
      p = 0;
    } 
    return p;
  }
  static double N5cf7ee71178(Object []i) {
    double p = Double.NaN;
    if (i[63] == null) {
      p = 17;
    } else if (((Double) i[63]).doubleValue() <= 0.006521) {
      p = 17;
    } else if (((Double) i[63]).doubleValue() > 0.006521) {
    p = J48WekaClassifier.N6640fe18179(i);
    } 
    return p;
  }
  static double N6640fe18179(Object []i) {
    double p = Double.NaN;
    if (i[85] == null) {
      p = 11;
    } else if (((Double) i[85]).doubleValue() <= 0.008601) {
    p = J48WekaClassifier.N39507394180(i);
    } else if (((Double) i[85]).doubleValue() > 0.008601) {
      p = 2;
    } 
    return p;
  }
  static double N39507394180(Object []i) {
    double p = Double.NaN;
    if (i[65] == null) {
      p = 11;
    } else if (((Double) i[65]).doubleValue() <= 0.006969) {
      p = 11;
    } else if (((Double) i[65]).doubleValue() > 0.006969) {
    p = J48WekaClassifier.N5935329c181(i);
    } 
    return p;
  }
  static double N5935329c181(Object []i) {
    double p = Double.NaN;
    if (i[17] == null) {
      p = 15;
    } else if (((Double) i[17]).doubleValue() <= 0.007279) {
      p = 15;
    } else if (((Double) i[17]).doubleValue() > 0.007279) {
      p = 19;
    } 
    return p;
  }
}
