/*     */ package gts.modernization.util;
/*     */ import java.io.IOException;

/*     */ import org.antlr.runtime.ANTLRFileStream;
/*     */ import org.antlr.runtime.CharStream;
/*     */ import org.antlr.runtime.CommonTokenStream;
/*     */ import org.apache.tools.ant.Task;
/*     */ import org.eclipse.emf.common.util.URI;
/*     */ import org.eclipse.emf.ecore.resource.Resource;
/*     */ import org.eclipse.emf.ecore.resource.ResourceSet;
/*     */ import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
/*     */ import org.eclipse.emf.ecore.xmi.impl.EcoreResourceFactoryImpl;

/*     */ 
/*     */ import gts.modernization.interpreter.Gra2MoLInterpreter;
/*     */ import gts.modernization.model.CST.Element;
/*     */ import gts.modernization.model.CST.impl.CSTPackageImpl;
/*     */ import gts.modernization.model.Gra2MoL.Core.ViewDefinition;
/*     */ import gts.modernization.parser.gra2mol.Gra2MoLLexer;
/*     */ import gts.modernization.parser.gra2mol.Gra2MoLParser;
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ public class Gra2MoLInterpreterAntTask
/*     */   extends Task
/*     */ {
/*  36 */   private String pathSourceView = "";
/*  37 */   private String pathSourceCST = "";
/*  38 */   private String pathMetamodel = "";
/*  39 */   private String targetMetamodel = "";
/*  40 */   private String result = "";
/*     */   
/*     */   public String getPathSourceView() {
/*  43 */     return this.pathSourceView;
/*     */   }
/*     */   
/*     */   public void setPathSourceView(String pathSourceView) {
/*  47 */     this.pathSourceView = pathSourceView;
/*     */   }
/*     */   
/*     */   public String getPathSourceCST() {
/*  51 */     return this.pathSourceCST;
/*     */   }
/*     */   
/*     */   public void setPathSourceCST(String pathSourceCST) {
/*  55 */     this.pathSourceCST = pathSourceCST;
/*     */   }
/*     */   
/*     */   public String getPathMetamodel() {
/*  59 */     return this.pathMetamodel;
/*     */   }
/*     */   
/*     */   public void setPathMetamodel(String pathMetamodel) {
/*  63 */     this.pathMetamodel = pathMetamodel;
/*     */   }
/*     */   
/*     */   public String getTargetMetamodel() {
/*  67 */     return this.targetMetamodel;
/*     */   }
/*     */   
/*     */   public void setTargetMetamodel(String targetMetamodel) {
/*  71 */     this.targetMetamodel = targetMetamodel;
/*     */   }
/*     */   
/*     */   public String getResult() {
/*  75 */     return this.result;
/*     */   }
/*     */   
/*     */   public void setResult(String result) {
/*  79 */     this.result = result;
/*     */   }
/*     */   
/*     */   public void execute()
/*     */   {
/*  84 */     ViewDefinition view = loadView(this.pathSourceView);
/*  85 */     saveView("gra2molModel.ecore", view);
/*     */     
/*  87 */     Element e = loadCST(this.pathSourceCST);
/*     */     try
/*     */     {
/*  90 */       long startTime = System.currentTimeMillis();
/*  91 */       log("Executing transformation...");
/*  92 */       Gra2MoLInterpreter interpreter = new Gra2MoLInterpreter(e, view, this.pathMetamodel, this.targetMetamodel, this.result);
/*  93 */       interpreter.execute();
/*  94 */       long endTime = System.currentTimeMillis() - startTime;
/*  95 */       log(" (" + endTime + " milisecs)");
/*     */     } catch (Exception ex) {
/*  97 */       ex.printStackTrace();
/*     */     }
/*     */   }
/*     */   
/*     */ 
/*     */ 
/*     */   public static void main(String[] args)
/*     */   {
/* 105 */     Gra2MoLInterpreterAntTask task = new Gra2MoLInterpreterAntTask();
/* 106 */     task.setPathSourceView("../Grammar2Model/files/okivista.view");
/* 107 */     task.setPathSourceCST("../Grammar2Model/files/oki.java.ecore");
/* 108 */     task.setPathMetamodel("../Grammar2Model/metamodel/struts.ecore");
/* 109 */     task.setTargetMetamodel("StrutsMM");
/* 110 */     task.setResult("../Grammar2Model/debug/oki.ecore");
/* 111 */     task.execute();
/*     */   }
/*     */   
/*     */   public ViewDefinition loadView(String path) {
/*     */     try {
/* 116 */       CharStream input = new ANTLRFileStream(path);
/* 117 */       Gra2MoLLexer lex = new Gra2MoLLexer(input);
/* 118 */       CommonTokenStream tokens = new CommonTokenStream(lex);
/* 119 */       Gra2MoLParser parser = new Gra2MoLParser(tokens);
/* 120 */       Gra2MoLParser.viewDefinition_return r = parser.viewDefinition();
/* 121 */       return r.viewReturn;
/*     */     } catch (Exception e) {
/* 123 */       e.printStackTrace();
/*     */     }
/* 125 */     return null;
/*     */   }
/*     */   
/*     */   public Element loadCST(String path) {
/* 129 */     ResourceSet rs = new ResourceSetImpl();
/* 130 */     rs.getResourceFactoryRegistry().getExtensionToFactoryMap().put("ecore", new EcoreResourceFactoryImpl());
/* 131 */     rs.getPackageRegistry().put("http://gts.inf.um.es/modernization/cst", CSTPackageImpl.eINSTANCE);
/*     */     
/* 133 */     Resource r = rs.getResource(URI.createFileURI(path), true);
/* 134 */     Element t = null;
/*     */     try {
/* 136 */       r.load(null);
/* 137 */       t = (Element)r.getContents().get(0);
/*     */     } catch (Exception e) {
/* 139 */       e.printStackTrace();
/*     */     }
/* 141 */     return t;
/*     */   }
/*     */   
/*     */   public void saveView(String path, ViewDefinition n)
/*     */   {
/* 146 */     ResourceSet rs = new ResourceSetImpl();
/* 147 */     rs.getResourceFactoryRegistry().getExtensionToFactoryMap().put("ecore", new EcoreResourceFactoryImpl());
/* 148 */     Resource r = rs.createResource(URI.createFileURI(path));
/*     */     try {
/* 150 */       r.getContents().add(n);
/* 151 */       r.save(null);
/*     */     } catch (IOException e) {
/* 153 */       e.printStackTrace();
/*     */     }
/*     */   }
/*     */ }
