/*     */ package gts.modernization.util;
/*     */ 
/*     */ import gts.modernization.parser.antlr.ANTLRv3Lexer;
/*     */ import gts.modernization.parser.antlr.ANTLRv3Parser;
/*     */ import gts.modernization.parser.antlr.ANTLRv3Parser.grammarDef_return;
/*     */ import gts.modernization.parser.antlr.G2Ge;
/*     */ import java.io.FileNotFoundException;
/*     */ import java.io.FileReader;
/*     */ import java.io.FileWriter;
/*     */ import java.io.IOException;
/*     */ import java.io.PrintStream;
/*     */ import org.antlr.runtime.CharStream;
/*     */ import org.antlr.runtime.RecognitionException;
/*     */ import org.antlr.runtime.TokenRewriteStream;
/*     */ import org.antlr.runtime.tree.CommonTree;
/*     */ import org.antlr.runtime.tree.CommonTreeNodeStream;
/*     */ import org.antlr.stringtemplate.StringTemplateGroup;
/*     */ import org.apache.tools.ant.BuildException;
/*     */ import org.apache.tools.ant.Task;
/*     */ 
/*     */ public class G2GeAntTask extends Task
/*     */ {
/*     */   private String pathGrammar;
/*     */   private String pathResult;
/*  25 */   private String pathTemplates = "templates/G2Ge.stg";
/*     */   
/*     */   public String getPathTemplates() {
/*  28 */     return this.pathTemplates;
/*     */   }
/*     */   
/*     */   public void setPathTemplates(String pathTemplates) {
/*  32 */     this.pathTemplates = pathTemplates;
/*     */   }
/*     */   
/*     */   public String getPathGrammar() {
/*  36 */     return this.pathGrammar;
/*     */   }
/*     */   
/*     */   public void setPathGrammar(String pathGrammar) {
/*  40 */     this.pathGrammar = pathGrammar;
/*     */   }
/*     */   
/*     */   public String getPathResult() {
/*  44 */     return this.pathResult;
/*     */   }
/*     */   
/*     */   public void setPathResult(String pathResult) {
/*  48 */     this.pathResult = pathResult;
/*     */   }
/*     */   
/*     */   public void execute() throws BuildException {
/*  52 */     TokenRewriteStream tokens = null;
/*     */     try
/*     */     {
/*  55 */       CharStream input = new org.antlr.runtime.ANTLRFileStream(this.pathGrammar);
/*     */       
/*  57 */       ANTLRv3Lexer lex = new ANTLRv3Lexer(input);
/*     */       
/*  59 */       tokens = new TokenRewriteStream(lex);
/*     */     } catch (IOException e) {
/*  61 */       System.err.println("Error reading the grammar definition");
/*  62 */       e.printStackTrace();
/*  63 */       return;
/*     */     }
/*     */     
/*  66 */     ANTLRv3Parser.grammarDef_return r = null;
/*     */     try
/*     */     {
/*  69 */       ANTLRv3Parser parser = new ANTLRv3Parser(tokens);
/*  70 */       r = parser.grammarDef();
/*     */     } catch (RecognitionException e) {
/*  72 */       System.err.println("Error parsing the grammar definition");
/*  73 */       e.printStackTrace();
/*  74 */       return;
/*     */     }
/*     */     
/*     */ 
/*  78 */     CommonTree t = (CommonTree)r.getTree();
/*     */     
/*     */ 
/*  81 */     CommonTreeNodeStream nodes = new CommonTreeNodeStream(t);
/*  82 */     nodes.setTokenStream(tokens);
/*     */     
/*  84 */     StringTemplateGroup stg = null;
/*     */     try
/*     */     {
/*  87 */       FileReader fr = new FileReader(this.pathTemplates);
/*  88 */       stg = new StringTemplateGroup(fr);
/*  89 */       fr.close();
/*     */     } catch (FileNotFoundException e) {
/*  91 */       System.err.println("Templates file not found");
/*  92 */       e.printStackTrace();
/*  93 */       return;
/*     */     } catch (IOException e) {
/*  95 */       System.err.println("Problem reading templates file");
/*  96 */       e.printStackTrace();
/*  97 */       return;
/*     */     }
/*     */     
/*     */     try
/*     */     {
/* 102 */       G2Ge walker = new G2Ge(nodes, this.pathTemplates);
/* 103 */       walker.setTemplateLib(stg);
/* 104 */       walker.grammarDef();
/* 105 */       String tokens2 = tokens.toString();
/* 106 */       write2Disk(tokens2, this.pathResult);
/*     */     } catch (RecognitionException e) {
/* 108 */       System.err.println("Error walking the grammar");
/* 109 */       e.printStackTrace();
/* 110 */       return;
/*     */     }
/*     */   }
/*     */   
/*     */   public static void write2Disk(String contain, String path) {
/*     */     try {
/* 116 */       FileWriter fw = new FileWriter(path);
/* 117 */       fw.write(contain);
/* 118 */       fw.close();
/*     */     } catch (Exception e) {
/* 120 */       System.out.println("Error al guardar");
/* 121 */       e.printStackTrace();
/*     */     }
/*     */   }
/*     */   
/*     */   public static void main(String[] args) {
/* 126 */     G2GeAntTask task = new G2GeAntTask();
/* 127 */     task.setPathGrammar(args[0]);
/* 128 */     task.setPathResult(args[1]);
/*     */     
/*     */ 
/* 131 */     task.execute();
/*     */   }
/*     */ }
