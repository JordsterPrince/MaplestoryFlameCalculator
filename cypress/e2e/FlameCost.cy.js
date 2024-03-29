 
describe('Flame Calculator Cost', () => { 
  it('Checks the cost ifyou want to improve flame score by 10', () => { 
    // Visit the website 
    cy.visit('https://brendonmay.github.io/flameCalculator/'); 
    // Wait for the checkbox to be visible and clickable 
    cy.wait(2000); 
    cy.get('.ml-2 > span').click(); 
    cy.get('#desired_stat_armor').click().clear().type('166'); 
    cy.get('#calculateButton').click(); 
    cy.wait(1000); 
    // Capture text from an element and save it to a file 
    cy.get('#result').invoke('text').then(text => { 
    cy.writeFile('cost.txt', text.trim()); 
    }); 
  }); 
}); 
