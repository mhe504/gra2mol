/*     */ package gts.modernization.util;
/*     */ 
/*     */ import java.io.FileWriter;
/*     */ import java.io.PrintStream;
/*     */ import org.antlr.stringtemplate.StringTemplate;
/*     */ import org.antlr.stringtemplate.StringTemplateGroup;
/*     */ import org.antlr.stringtemplate.language.DefaultTemplateLexer;
/*     */ import org.apache.tools.ant.BuildException;
/*     */ import org.apache.tools.ant.Task;
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ public class Ge2TestParser
/*     */   extends Task
/*     */ {
/*  34 */   private String grammar = null;
/*  35 */   private String mainRule = null;
/*     */   private String result;
/*  37 */   private String resultParser = "noDefined";
/*  38 */   private String pathLanguage = "noDefined";
/*  39 */   private String pathTemplate = "./templates";
/*     */   
/*     */   public String getPathLanguage() {
/*  42 */     return this.pathLanguage;
/*     */   }
/*     */   
/*     */   public void setPathLanguage(String pathLanguage) {
/*  46 */     this.pathLanguage = pathLanguage;
/*     */   }
/*     */   
/*     */   public String getPathTemplate() {
/*  50 */     return this.pathTemplate;
/*     */   }
/*     */   
/*     */   public void setPathTemplate(String pathTemplate) {
/*  54 */     this.pathTemplate = pathTemplate;
/*     */   }
/*     */   
/*     */   public String getGrammar() {
/*  58 */     return this.grammar;
/*     */   }
/*     */   
/*     */   public void setGrammar(String grammar) {
/*  62 */     this.grammar = grammar;
/*     */   }
/*     */   
/*     */   public String getMainRule() {
/*  66 */     return this.mainRule;
/*     */   }
/*     */   
/*     */   public void setMainRule(String mainRule) {
/*  70 */     this.mainRule = mainRule;
/*     */   }
/*     */   
/*     */   public String getResult() {
/*  74 */     return this.result;
/*     */   }
/*     */   
/*     */   public void setResult(String result) {
/*  78 */     this.result = result;
/*     */   }
/*     */   
/*     */   public String getResultParser() {
/*  82 */     return this.resultParser;
/*     */   }
/*     */   
/*     */   public void setResultParser(String resultParser) {
/*  86 */     this.resultParser = resultParser;
/*     */   }
/*     */   
/*     */   public void execute() throws BuildException {
/*     */     try {
/*  91 */       StringTemplateGroup group = new StringTemplateGroup("myGroup", this.pathTemplate, DefaultTemplateLexer.class);
/*  92 */       StringTemplate parser = group.getInstanceOf("parser");
/*     */       
/*  94 */       parser.setAttribute("pathLanguage", this.pathLanguage);
/*  95 */       parser.setAttribute("grammar", this.grammar);
/*  96 */       parser.setAttribute("mainRule", this.mainRule);
/*  97 */       parser.setAttribute("path", this.resultParser);
/*     */       
/*  99 */       FileWriter fw = new FileWriter(this.result + "/" + this.grammar + "Test.java");
/* 100 */       fw.write(parser.toString());
/* 101 */       fw.close();
/* 102 */       System.out.println("Test Parser created in: " + this.result + "/" + this.grammar + "Test.java (" + this.resultParser + ")");
/*     */     } catch (Exception e) {
/* 104 */       throw new BuildException(e.getCause());
/*     */     }
/*     */   }
/*     */   
/*     */   public static void main(String[] args) {
/* 109 */     Ge2TestParser task = new Ge2TestParser();
/* 110 */     task.setGrammar("Java");
/* 111 */     task.setMainRule("compilation_unit");
/* 112 */     task.setResult("files");
/* 113 */     task.setPathLanguage("../Grammar2Model.Test/files/prueba.java");
/* 114 */     task.execute();
/*     */   }
/*     */ }

