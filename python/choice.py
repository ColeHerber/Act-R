import actr
import numpy as np
actr.load_act_r_model("ACT-R:tutorial;unit6;choice-model.lisp")
choice_data = [0.664, 0.778, 0.804, 0.818]
response = False
virtual_mode = True


def dominant_accuracy(response):
    if response.count("h") > response.count("t"):
        dominant = "h"
    else:
        dominant = "t"
    return np.mean(np.array(response)==dominant)
    #returns mean of response amounts

def respond_to_key_press (model,key):
    global response
    response = key

def trial(window,probability,person=False):
    global response

    actr.add_command("choice-response",respond_to_key_press,"Choice task key response")
    actr.monitor_command("output-key","choice-response")

    actr.add_text_to_exp_window (window, 'choose', x=50, y=100)

    response = ''

    if person: 
        while response == '':
            actr.process_events()
    else:
        actr.run(1,not virtual_mode)

    actr.clear_exp_window(window)

    if actr.random(1.0) < probability:
        answer = 'heads'
    else:
        answer = 'tails'

    actr.add_text_to_exp_window (window, answer, x=50, y=100)

    start = actr.get_time(False)

    if person:
        while (actr.get_time(False) - start) < 1000:
            actr.process_events()#IF NOT HERE RIDICULOUS PAUSE
            #make sure person defaults to false
    else:
        actr.run(1,not virtual_mode)
    actr.clear_exp_window(window)
    actr.remove_command_monitor("output-key","choice-response")
    actr.remove_command("choice-response")

    return response

def block(block_id,probability,person=False):
    block_res = []
    window = actr.open_exp_window("Choice Experiment",visible=False)
    actr.install_device(window)
    for i in range(12):
        response = trial(window,probability,person)
        block_res.append(response)
    res = dominant_accuracy(block_res)

    #print("Block-",block_id+1,"\tAccuracy=",hratio)
    return res


def model(num_block=4,probability=0.5,person=False):
    result_list = []
    for i in range(num_block):
        result_list.append(block(i,probability,person))
    return result_list


def data(n=100):#have to set variable because must have no required perameiters
    window = actr.open_exp_window("Coin Flip Task",visible=True,width=300,height=300)
    results = []#not numpy because numpy is bad at appending to lists
    for i in range(n):
        print(i)#anti hang code(2 hours i'm never getting back)┌( ಠ_ಠ )┘
        results.append(model(probability=0.9))
        results.append(model(probability=0.1))
        #compares 200 runs

    #convert to numpy for mean functions
    results = np.array(results)
    avg_result = list(np.mean(results,axis=0)) #need axis to get output list
    correlation=actr.correlation(avg_result,choice_data)
    mean_deviation=actr.mean_deviation(avg_result,choice_data)
    
    stats = f"""Original Current \n
        {float(choice_data[0])} {float(avg_result[0])} \n
        {float(choice_data[1])} {float(avg_result[1])} \n
        {float(choice_data[2])} {float(avg_result[2])} \n
        {float(choice_data[3])} {float(avg_result[3])}"""
    corr = "CORRELATION: " + str(correlation)
    md = "MEAN DEVIATION: " + str(mean_deviation)
    print(corr)
    print(md)
    print(stats)
    #forgot I had to display grrr
    actr.add_text_to_exp_window(window, corr, x=20, y=50)
    actr.add_text_to_exp_window(window, md, x=20, y=70)
    actr.add_text_to_exp_window(window, stats, x=20, y=90)

        
    
    
#auto run for 100
data(n=100) 