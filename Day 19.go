package main

import (  
  "fmt"
  "io/ioutil"
  "strings"
  "regexp"
  "bytes"
)



type Rule struct{
  initial string
  processed bool
  rule string
  id string
}

var rulemap map[string]Rule


func newRule(id string, rule string) Rule {
  return Rule{
    initial: rule,
    processed: false,
    id: id,
  }
}

func (r *Rule) process() {
  if(len(r.initial) == 1){
    if(r.initial=="a" || r.initial == "b"){
      r.rule=r.initial; return
    }
  }
  links := strings.Split(r.initial, " ")
  var buffer bytes.Buffer
  for _, id := range links {
    if(id == "|"){ buffer.WriteString(id);continue }
    buffer.WriteString(rulemap[id].getRule())
  }
  if(strings.Contains(r.initial, "|")){
   s:=buffer.String()
   buffer.Reset()
   buffer.WriteString("(?:")
   buffer.WriteString(s)
   buffer.WriteString(")")
  }
  r.rule = buffer.String()
  r.processed = true
}

func (r Rule) getRule() string {
  if(!r.processed){ r.process() }
  return r.rule
}

func (r Rule) setRule(nr string) { r.rule = nr; r.processed=true }
func (r Rule) forceReprocess(){ 
  r.rule = ""
  r.processed=false
  r.process()
}

func (r Rule) compile() *regexp.Regexp {
  var buffer bytes.Buffer
  buffer.WriteString("(?m)^")
  buffer.WriteString(r.getRule())
  buffer.WriteString("$")
  re, err := regexp.Compile(buffer.String())
  if err != nil { panic(err) }
  return re
}


func par2_reprocess8and11() {
  var buffer bytes.Buffer
  buffer.WriteString("(?:")
  buffer.WriteString(rulemap["42"].getRule())
  buffer.WriteString(")+?")
  rulemap["8"] = Rule{
    initial: "",
    processed: true,
    id: "8",
    rule: buffer.String(),
  }
  
  s := ""
  l := 10
  for i:= 0; i<l;i++ {
    buffer.Reset()
    buffer.WriteString("(?:")
    buffer.WriteString(rulemap["42"].getRule())
    buffer.WriteString(s)
    buffer.WriteString(rulemap["31"].getRule())
    buffer.WriteString(")")
    if i < l-1 {
      buffer.WriteString("?")
    }
    s=buffer.String()
  }
  
  rulemap["11"] = Rule{
    initial: "",
    processed: true,
    id: "11",
    rule: s,
  }
  rulemap["0"].forceReprocess()
}



func processRules(input string){
  re := regexp.MustCompile(`(?m)^(\d+): \"?(\w|(?:\d ?\|? ?)+)\"?$`)
  rules := re.FindAllStringSubmatch(input, -1)
  for _, s := range rules {
    rulemap[s[1]] = newRule(s[1],s[2])
  }
}

func contains(s []string, str string) bool {
	for _, v := range s {if v == str {return true}}
	return false
}

func main() {
  rulemap = make(map[string]Rule)

  textData, err := ioutil.ReadFile("input.txt")
  if err != nil {
      fmt.Println("File reading error", err)
      return
  }else{
	  
	  pieces := strings.Split(string(textData),"\n\n")
	  processRules(pieces[0])
	  
	  answerPart1 := len(rulemap["0"].compile().FindAllStringIndex(pieces[1],-1))
	  fmt.Println("Answer Part 1:",answerPart1)
	  
	  par2_reprocess8and11()
	  answerPart2 := len(rulemap["0"].compile().FindAllStringIndex(pieces[1],-1))
	  fmt.Println("Answer Part 2:",answerPart2)
  }
}
