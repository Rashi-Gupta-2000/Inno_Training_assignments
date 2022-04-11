import './App.css';
import { useState,useEffect } from 'react';
import Card from './Components/Card';

const CardImages = [
  {"src":"/images/cap.jpg",matched: false},
  {"src":"/images/flower.jpg",matched: false},
  {"src":"/images/mirror.jpg",matched: false},
  {"src":"/images/potion.jpg",matched: false},
  {"src":"/images/sword.jpg",matched: false},
  {"src":"/images/scroll.jpg",matched: false},
]

// const Handler = () => {
//   return card
// }


function App() {
  const[cards,setCards] = useState([])
  const[turns,setTurns] = useState(0)
  const[openOne,setOne] = useState(null)
  const[openTwo,setTwo] = useState(null)
  const[disableCard,setDisable] = useState(false)
  

  const shuffle = () => {
  const shuffle = [...CardImages,...CardImages]
      .sort(() => Math.random() - 0.5)
      .map((card) => ({...card, id: Math.random() }))

  setOne(null)
  setTwo(null)
  setCards(shuffle)
  setTurns(0)
  }

  console.log(cards,turns)

  //handle the choice
  const choiceHandler = (card) => {
    openOne ? setTwo(card) : setOne(card)
  }

  //comapre 2 selected cards
  useEffect(() => {
    if(openOne && openTwo){
      setDisable(true)
      if(openOne.src === openTwo.src){
        setCards(prevCards => {
          return prevCards.map(card => {
            if(card.src === openOne.src){
              return{...card, matched: true}
            }else{
              return card
            }
          })
        })
        resetTurns()
      }else{
        setTimeout(() => resetTurns(), 1000)
      }
    }
  },[openOne,openTwo])

  useEffect(() => {
    shuffle()
}, [])
  
  //reset choices and increase turns
  const resetTurns = () => {
    setOne(null)
    setTwo(null)
    setTurns(prevTurns => prevTurns+1)
    setDisable(false)
  }

  return (
    <div className="App">
      <h1>Magic Match</h1>
      <button onClick={shuffle}>New Game</button>

      <div className='card-grid'>
        {cards.map(card => (
          <Card 
            key = {card.id} 
            card={card}
            handleChoice={choiceHandler}
            flipped={card === openOne || card === openTwo || card.matched}
            disableCard={disableCard}
          />
        ))}
      </div>
      <p>Turns: {turns}</p>
    </div>
  );
}

export default App;
