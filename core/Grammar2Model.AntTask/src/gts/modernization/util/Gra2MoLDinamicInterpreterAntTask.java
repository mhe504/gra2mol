/*     */ package gts.modernization.util;
/*     */ import java.io.File;
/*     */ import java.io.IOException;
/*     */ import java.lang.reflect.Constructor;
/*     */ import java.lang.reflect.Field;
/*     */ import java.lang.reflect.Member;
/*     */ import java.lang.reflect.Method;
/*     */ import java.util.Iterator;
/*     */ import java.util.Vector;

/*     */ import org.antlr.runtime.ANTLRFileStream;
/*     */ import org.antlr.runtime.CharStream;
/*     */ import org.antlr.runtime.CommonTokenStream;
/*     */ import org.antlr.runtime.Lexer;
/*     */ import org.antlr.runtime.TokenStream;
/*     */ import org.apache.tools.ant.DirectoryScanner;
/*     */ import org.apache.tools.ant.taskdefs.MatchingTask;
/*     */ import org.apache.tools.ant.types.FileSet;
/*     */ import org.eclipse.emf.common.util.URI;
/*     */ import org.eclipse.emf.ecore.resource.Resource;
/*     */ import org.eclipse.emf.ecore.resource.ResourceSet;
/*     */ import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
/*     */ import org.eclipse.emf.ecore.xmi.impl.EcoreResourceFactoryImpl;

/*     */ 
/*     */ import gts.modernization.interpreter.Gra2MoLInterpreter;
/*     */ import gts.modernization.model.CST.CSTFactory;
/*     */ import gts.modernization.model.CST.Element;
/*     */ import gts.modernization.model.CST.Leaf;
/*     */ import gts.modernization.model.CST.Node;
/*     */ import gts.modernization.model.Gra2MoL.Core.ViewDefinition;
/*     */ import gts.modernization.parser.gra2mol.Gra2MoLLexer;
/*     */ import gts.modernization.parser.gra2mol.Gra2MoLParser;
/*     */ 
/*     */ public class Gra2MoLDinamicInterpreterAntTask extends MatchingTask
/*     */ {
/*  40 */   private String pathSourceView = "";
/*     */   
/*     */ 
/*     */ 
/*  44 */   private String pathMetamodel = "";
/*     */   
/*     */ 
/*     */ 
/*  48 */   private String targetMetamodel = "";
/*     */   
/*     */ 
/*     */ 
/*  52 */   private String result = "";
/*     */   
/*     */ 
/*     */ 
/*  56 */   private String className = "";
/*     */   
/*     */ 
/*     */ 
/*  60 */   private String pathFiles = "";
/*     */   
/*     */ 
/*     */ 
/*  64 */   private Vector filesets = new Vector();
/*     */   
/*     */ 
/*     */ 
/*     */ 
/*     */   private Element globalCST;
/*     */   
/*     */ 
/*     */ 
/*     */   private String grammar;
/*     */   
/*     */ 
/*     */ 
/*     */   private String mainRule;
/*     */   
/*     */ 
/*     */ 
/*  81 */   private boolean caseSensitive = true;
/*     */   
/*     */   public String getGrammar() {
/*  84 */     return this.grammar;
/*     */   }
/*     */   
/*     */   public void setGrammar(String grammar) {
/*  88 */     this.grammar = grammar;
/*     */   }
/*     */   
/*     */   public String getMainRule() {
/*  92 */     return this.mainRule;
/*     */   }
/*     */   
/*     */   public void setMainRule(String mainRule) {
/*  96 */     this.mainRule = mainRule;
/*     */   }
/*     */   
/*     */   public void addFileset(FileSet fileset) {
/* 100 */     this.filesets.add(fileset);
/*     */   }
/*     */   
/*     */   public String getPathSourceView() {
/* 104 */     return this.pathSourceView;
/*     */   }
/*     */   
/*     */   public void setPathSourceView(String pathSourceView) {
/* 108 */     this.pathSourceView = pathSourceView;
/*     */   }
/*     */   
/*     */   public String getPathMetamodel() {
/* 112 */     return this.pathMetamodel;
/*     */   }
/*     */   
/*     */   public void setPathMetamodel(String pathMetamodel) {
/* 116 */     this.pathMetamodel = pathMetamodel;
/*     */   }
/*     */   
/*     */   public String getTargetMetamodel() {
/* 120 */     return this.targetMetamodel;
/*     */   }
/*     */   
/*     */   public void setTargetMetamodel(String targetMetamodel) {
/* 124 */     this.targetMetamodel = targetMetamodel;
/*     */   }
/*     */   
/*     */   public String getResult() {
/* 128 */     return this.result;
/*     */   }
/*     */   
/*     */   public void setResult(String result) {
/* 132 */     this.result = result;
/*     */   }
/*     */   
/*     */   public String getClassName() {
/* 136 */     return this.className;
/*     */   }
/*     */   
/*     */   public void setClassName(String className) {
/* 140 */     this.className = className;
/*     */   }
/*     */   
/*     */   public String getPathFiles() {
/* 144 */     return this.pathFiles;
/*     */   }
/*     */   
/* 147 */   public void setPathFiles(String pathFiles) { this.pathFiles = pathFiles; }
/*     */   
/*     */   public void setCaseSensitive(boolean caseSensitive)
/*     */   {
/* 151 */     this.caseSensitive = caseSensitive;
/*     */   }
/*     */   
/* 154 */   public boolean getCaseSensitive() { return this.caseSensitive; }
/*     */   
/*     */ 
/*     */   public void execute()
/*     */   {
/* 159 */     ViewDefinition view = loadView(this.pathSourceView);
/* 160 */     saveView("gra2molModel.ecore", view);
/*     */     
/*     */ 
/*     */     try
/*     */     {
/* 165 */       this.globalCST = initializeGlobalCST();
/*     */       
/* 167 */       long startTime = System.currentTimeMillis();
/*     */       
/* 169 */       Iterator it = this.filesets.iterator();
/* 170 */       while (it.hasNext()) {
/* 171 */         FileSet fset = (FileSet)it.next();
/* 172 */         if (fset != null) {
/* 173 */           log("Parsing fileset...");
/* 174 */           DirectoryScanner ds = fset.getDirectoryScanner(getProject());
/* 175 */           File dirFile = ds.getBasedir();
/* 176 */           String dir = dirFile.getAbsolutePath();
/* 177 */           String[] files = ds.getIncludedFiles();
/* 178 */           for (int i = 0; i < files.length; i++) {
/* 179 */             String file = dir + File.separator + files[i];
/*     */             try {
/* 181 */               Element e = parser(file);
/*     */               
/* 183 */               addCST(e, file, files[i]);
/*     */             }
/*     */             catch (Exception e) {
/* 186 */               log("  ERROR in file: " + file);
log(e.getMessage());
StackTraceElement[] stackTrace = e.getStackTrace();
for (StackTraceElement ste : stackTrace)
{
	log(ste.toString());
}

/*     */             }
/*     */           }
/*     */         }
/*     */       }
/*     */       
/*     */ 
/* 193 */       long endTime = System.currentTimeMillis() - startTime;
/* 194 */       log(" (" + endTime + " milisecs)");
/*     */       
/* 196 */       log("Saving CST...");
/*     */       
/* 198 */       saveCST("CSTModel.ecore", (Node)this.globalCST);
/*     */       
/*     */ 
/*     */ 
/*     */ 
/* 203 */       log("Executing transformation...");
/* 204 */       startTime = System.currentTimeMillis();
/*     */       
				System.out.println(this.pathMetamodel);
/* 206 */       Gra2MoLInterpreter interpreter = new Gra2MoLInterpreter(this.globalCST, view, this.pathMetamodel, this.targetMetamodel, this.result);
/* 207 */       interpreter.execute();
/* 208 */       endTime = System.currentTimeMillis() - startTime;
/* 209 */       log(" (" + endTime + " milisecs)");
/*     */     } catch (Exception ex) {
/* 211 */       ex.printStackTrace();
/*     */     }
/*     */   }
/*     */   
/*     */   public Element initializeGlobalCST() {
/* 216 */     Node sol = CSTFactory.eINSTANCE.createNode();
/* 217 */     sol.setKind("CST");
/*     */     
/* 219 */     return sol;
/*     */   }
/*     */   
/*     */   public void addCST(Element specific, String path, String filename) {
/* 223 */     if (((this.globalCST instanceof Node)) && ((specific instanceof Node))) {
/* 224 */       Node globalNode = (Node)this.globalCST;
/* 225 */       Node specficidNode = (Node)specific;
/*     */       
/* 227 */       Node file = CSTFactory.eINSTANCE.createNode();
/* 228 */       file.setKind("file");
/*     */       
/* 230 */       Leaf pathLeaf = CSTFactory.eINSTANCE.createLeaf();
/* 231 */       pathLeaf.setKind("path");
/* 232 */       pathLeaf.setValue(path);
/*     */       
/* 234 */       Leaf pathFileName = CSTFactory.eINSTANCE.createLeaf();
/* 235 */       pathFileName.setKind("filename");
/* 236 */       pathFileName.setValue(filename);
/*     */       
/* 238 */       file.getChildren().add(pathLeaf);
/* 239 */       file.getChildren().add(pathFileName);
/* 240 */       file.getChildren().add(specficidNode);
/*     */       
/*     */ 
/* 243 */       globalNode.getChildren().add(file);
/*     */     }
/*     */   }
/*     */   
/*     */   public Node executeParser(String sourceFile) throws Exception {
/* 248 */     Object o = null;
/*     */     
/* 250 */     Class c = Class.forName(this.className);
/* 251 */     Object t = c.newInstance();
/*     */     
/*     */ 
/* 254 */     Method method = c.getMethod("parser", new Class[] { String.class });
/* 255 */     o = method.invoke(t, new Object[] { sourceFile });
/*     */     
/* 257 */     if ((o instanceof Node)) {
/* 258 */       Node node = (Node)o;
/* 259 */       return node;
/*     */     }
/* 261 */     return null;
/*     */   }
/*     */   
/*     */   class ANTLRNoCaseFileStream
/*     */     extends ANTLRFileStream
/*     */   {
/*     */     public ANTLRNoCaseFileStream(String fileName) throws IOException
/*     */     {
/* 269 */       super(null);
/*     */     }
/*     */     
/*     */     public ANTLRNoCaseFileStream(String fileName, String encoding) throws IOException
/*     */     {
/* 274 */       super(encoding);
/*     */     }
/*     */     
/*     */     public int LA(int i) {
/* 278 */       if (i == 0) {
/* 279 */         return 0;
/*     */       }
/* 281 */       if (i < 0) {
/* 282 */         i++;
/*     */       }
/* 284 */       if (this.p + i - 1 >= this.n) {
/* 285 */         return -1;
/*     */       }
/* 287 */       return Character.toUpperCase(this.data[(this.p + i - 1)]);
/*     */     }
/*     */   }
/*     */   
/*     */   public Node parser(String source) throws Exception {
/*     */     ANTLRFileStream afs;
/* 294 */     if (!this.caseSensitive) {
/* 295 */       System.out.println("Creating non case sensitive parser for " + source);
/* 296 */       afs = new ANTLRNoCaseFileStream(source);
/*     */     } else {
/* 298 */       System.out.println("Creating case sensitive parser for " + source);
/* 299 */       afs = new ANTLRFileStream(source);
/*     */     }
/*     */     
/*     */ 
/* 303 */     Class lexer = Class.forName(this.grammar + "Lexer");
/*     */     
/* 305 */     Constructor lexerConstructor = lexer.getConstructor(new Class[] { CharStream.class });
/*     */     
/* 307 */     Lexer lexerInstance = (Lexer)lexerConstructor.newInstance(new Object[] { afs });
/*     */     
/*     */ 
/* 310 */     CommonTokenStream cts = new CommonTokenStream(lexerInstance);
/*     */     
/*     */ 
/* 313 */     Class parser = Class.forName(this.grammar + "Parser");
/*     */     
/* 315 */     Constructor parserConstructor = parser.getConstructor(new Class[] { TokenStream.class });
/*     */     
/* 317 */     Object parserInstance = parserConstructor.newInstance(new Object[] { cts });
/*     */     
/*     */ 
/* 320 */     Method method = parser.getMethod(this.mainRule, null);
/*     */     
/* 322 */     Object returnedValue = method.invoke(parserInstance, null);
/*     */     
/* 324 */     Class returned = returnedValue.getClass();
/* 325 */     Field field = returned.getField("returnNode");
/* 326 */     Object o = field.get(returnedValue);
/*     */     
/* 328 */     if ((o instanceof Node)) {
/* 329 */       Node n = (Node)o;
/* 330 */       return n;
/*     */     }
/* 332 */     return null;
/*     */   }
/*     */   
/*     */   private static void printMembers(Member[] mbrs, String s)
/*     */   {
/* 337 */     System.out.format("%s:%n", new Object[] { s });
/* 338 */     Member[] arrayOfMember = mbrs;int j = mbrs.length; for (int i = 0; i < j; i++) { Member mbr = arrayOfMember[i];
/* 339 */       if ((mbr instanceof Field)) {
/* 340 */         System.out.format("  %s%n", new Object[] { ((Field)mbr).toGenericString() });
/* 341 */       } else if ((mbr instanceof Constructor)) {
/* 342 */         System.out.format("  %s%n", new Object[] { ((Constructor)mbr).toGenericString() });
/* 343 */       } else if ((mbr instanceof Method))
/* 344 */         System.out.format("  %s%n", new Object[] { ((Method)mbr).toGenericString() });
/*     */     }
/* 346 */     if (mbrs.length == 0)
/* 347 */       System.out.format("  -- No %s --%n", new Object[] { s });
/* 348 */     System.out.format("%n", new Object[0]);
/*     */   }
/*     */   
/*     */ 
/*     */   public static void main(String[] args)
/*     */   {
/* 354 */     Gra2MoLDinamicInterpreterAntTask task = new Gra2MoLDinamicInterpreterAntTask();
/*     */     
/*     */     try
/*     */     {
/* 358 */       task.setGrammar("Java");
/* 359 */       task.setMainRule("compilationUnit");
/* 360 */       task.parser("BeanTablon.java");
/*     */     } catch (Exception e) {
/* 362 */       e.printStackTrace();
/*     */     }
/*     */   }
/*     */   
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */   public ViewDefinition loadView(String path)
/*     */   {
/*     */     try
/*     */     {
/* 378 */       CharStream input = new ANTLRFileStream(path);
/* 379 */       Gra2MoLLexer lex = new Gra2MoLLexer(input);
/* 380 */       CommonTokenStream tokens = new CommonTokenStream(lex);
/* 381 */       Gra2MoLParser parser = new Gra2MoLParser(tokens);
/* 382 */       Gra2MoLParser.viewDefinition_return r = parser.viewDefinition();
/* 383 */       return r.viewReturn;
/*     */     } catch (Exception e) {
/* 385 */       e.printStackTrace();
/*     */     }
/* 387 */     return null;
/*     */   }
/*     */   
/*     */   public Element loadCST(String path) {
/* 391 */     ResourceSet rs = new ResourceSetImpl();
/* 392 */     rs.getResourceFactoryRegistry().getExtensionToFactoryMap().put("ecore", new EcoreResourceFactoryImpl());
/* 393 */     rs.getPackageRegistry().put("http://gts.inf.um.es/modernization/cst", gts.modernization.model.CST.impl.CSTPackageImpl.eINSTANCE);
/*     */     
/* 395 */     Resource r = rs.getResource(URI.createFileURI(path), true);
/* 396 */     Element t = null;
/*     */     try {
/* 398 */       r.load(null);
/* 399 */       t = (Element)r.getContents().get(0);
/*     */     } catch (Exception e) {
/* 401 */       e.printStackTrace();
/*     */     }
/* 403 */     return t;
/*     */   }
/*     */   
/*     */   public void saveView(String path, ViewDefinition n)
/*     */   {
/* 408 */     ResourceSet rs = new ResourceSetImpl();
/* 409 */     rs.getResourceFactoryRegistry().getExtensionToFactoryMap().put("ecore", new EcoreResourceFactoryImpl());
/* 410 */     Resource r = rs.createResource(URI.createFileURI(path));
/*     */     try {
/* 412 */       r.getContents().add(n);
/* 413 */       r.save(null);
/*     */     } catch (IOException e) {
/* 415 */       e.printStackTrace();
/*     */     }
/*     */   }
/*     */   
/*     */   public static void saveCST(String path, Node n) {
/* 420 */     ResourceSet rs = new ResourceSetImpl();
/* 421 */     rs.getResourceFactoryRegistry().getExtensionToFactoryMap().put("ecore", new EcoreResourceFactoryImpl());
/* 422 */     Resource r = rs.createResource(URI.createFileURI(path));
/*     */     try {
/* 424 */       r.getContents().add(n);
/* 425 */       r.save(null);
/*     */     } catch (IOException e) {
/* 427 */       e.printStackTrace();
/*     */     }
/*     */   }
/*     */ }
